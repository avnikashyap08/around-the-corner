"""
Around the Corner - FastAPI Backend
Run: uvicorn main:app --reload
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import psycopg2
import psycopg2.extras
import os

app = FastAPI(title="Around the Corner API", version="1.0.0")

# Allow frontend to talk to backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── DB Connection ─────────────────────────────────────────────────────────────
DB_CONFIG = {
    "dbname":   os.getenv("DB_NAME",     "around_the_corner"),
    "user":     os.getenv("DB_USER",     "postgres"),
    "password": os.getenv("DB_PASSWORD", "password"),
    "host":     os.getenv("DB_HOST",     "localhost"),
    "port":     os.getenv("DB_PORT",     "5432"),
}

def get_conn():
    return psycopg2.connect(**DB_CONFIG)

def query(sql: str, params=None) -> list[dict]:
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, params)
            return [dict(r) for r in cur.fetchall()]

def execute(sql: str, params=None):
    with get_conn() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, params)
            conn.commit()
            try:
                return dict(cur.fetchone())
            except Exception:
                return {}

# ── Pydantic Models ───────────────────────────────────────────────────────────
class ReviewIn(BaseModel):
    reviewer_name: str
    review_text:   Optional[str] = None
    rating:        float

# ── Routes ────────────────────────────────────────────────────────────────────

@app.get("/")
def root():
    return {"message": "Around the Corner API is running 🎉"}


@app.get("/categories")
def get_categories():
    return query("SELECT * FROM categories ORDER BY id")


@app.get("/places")
def get_places(
    category: Optional[str]  = Query(None, description="Filter by category name"),
    max_distance: Optional[float] = Query(None, description="Max distance in km"),
    max_cost: Optional[int]  = Query(None, description="Max avg cost per person"),
    min_rating: Optional[float]   = Query(None, description="Minimum rating"),
    search: Optional[str]    = Query(None, description="Search by name or description"),
):
    sql = """
        SELECT p.id, p.name, c.name AS category, c.icon,
               p.address, p.distance_km, p.avg_cost, p.rating,
               p.description, p.is_open
        FROM places p
        JOIN categories c ON p.category_id = c.id
        WHERE 1=1
    """
    params = []

    if category:
        sql += " AND LOWER(c.name) = LOWER(%s)"
        params.append(category)
    if max_distance is not None:
        sql += " AND p.distance_km <= %s"
        params.append(max_distance)
    if max_cost is not None:
        sql += " AND p.avg_cost <= %s"
        params.append(max_cost)
    if min_rating is not None:
        sql += " AND p.rating >= %s"
        params.append(min_rating)
    if search:
        sql += " AND (LOWER(p.name) LIKE LOWER(%s) OR LOWER(p.description) LIKE LOWER(%s))"
        params.extend([f"%{search}%", f"%{search}%"])

    sql += " ORDER BY p.rating DESC NULLS LAST"
    return query(sql, params)


@app.get("/places/{place_id}")
def get_place(place_id: int):
    rows = query("""
        SELECT p.id, p.name, c.name AS category, c.icon,
               p.address, p.distance_km, p.avg_cost, p.rating,
               p.description, p.is_open
        FROM places p
        JOIN categories c ON p.category_id = c.id
        WHERE p.id = %s
    """, [place_id])
    if not rows:
        raise HTTPException(status_code=404, detail="Place not found")
    return rows[0]


@app.get("/places/{place_id}/reviews")
def get_reviews(place_id: int):
    return query("""
        SELECT * FROM reviews
        WHERE place_id = %s
        ORDER BY created_at DESC
    """, [place_id])


@app.post("/places/{place_id}/reviews")
def add_review(place_id: int, review: ReviewIn):
    # Check place exists
    exists = query("SELECT id FROM places WHERE id = %s", [place_id])
    if not exists:
        raise HTTPException(status_code=404, detail="Place not found")

    result = execute("""
        INSERT INTO reviews (place_id, reviewer_name, review_text, rating)
        VALUES (%s, %s, %s, %s)
        RETURNING *
    """, [place_id, review.reviewer_name, review.review_text, review.rating])

    # Recalculate avg rating for the place
    execute("""
        UPDATE places
        SET rating = (SELECT ROUND(AVG(rating)::numeric, 1) FROM reviews WHERE place_id = %s)
        WHERE id = %s
    """, [place_id, place_id])

    return result


@app.get("/stats")
def get_stats():
    """Summary stats for the dashboard."""
    total     = query("SELECT COUNT(*) AS count FROM places")[0]["count"]
    by_cat    = query("""
        SELECT c.name, c.icon, COUNT(p.id) AS count
        FROM categories c
        LEFT JOIN places p ON p.category_id = c.id
        GROUP BY c.name, c.icon ORDER BY c.id
    """)
    avg_cost  = query("SELECT ROUND(AVG(avg_cost)) AS avg FROM places WHERE avg_cost > 0")[0]["avg"]
    top_rated = query("""
        SELECT p.name, p.rating, c.icon FROM places p
        JOIN categories c ON p.category_id = c.id
        ORDER BY p.rating DESC LIMIT 3
    """)
    return {
        "total_places": total,
        "by_category":  by_cat,
        "avg_cost":     avg_cost,
        "top_rated":    top_rated,
    }
