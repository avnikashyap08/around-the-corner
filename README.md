# Around the Corner 🗺️
A DBMS project to discover food, hangout, tourist, and essential spots near college.

## Project Structure
```
around-the-corner/
├── schema.sql      ← PostgreSQL DB schema + sample data
├── main.py         ← FastAPI backend
├── index.html      ← Frontend (open directly in browser)
├── requirements.txt
└── README.md
```

## Setup Instructions

### 1. PostgreSQL — Create the Database
```bash
psql -U postgres
\i schema.sql
```
This creates the DB, tables, and loads 17 sample places + reviews.

### 2. Backend — FastAPI
Install dependencies:
```bash
pip install fastapi uvicorn psycopg2-binary
```

Configure DB credentials (edit the `DB_CONFIG` dict in `main.py`, or set env vars):
```bash
export DB_NAME=around_the_corner
export DB_USER=postgres
export DB_PASSWORD=your_password
export DB_HOST=localhost
```

Run the server:
```bash
uvicorn main:app --reload
```
API will be live at: http://127.0.0.1:8000
Swagger docs at:    http://127.0.0.1:8000/docs

### 3. Frontend
Just open `index.html` in your browser. No build step needed.
Make sure the backend is running first.

---

## API Endpoints
| Method | Endpoint                        | Description                         |
|--------|---------------------------------|-------------------------------------|
| GET    | /places                         | List all places (supports filters)  |
| GET    | /places?category=Food           | Filter by category                  |
| GET    | /places?max_distance=1.0        | Filter by distance                  |
| GET    | /places?max_cost=100            | Filter by budget                    |
| GET    | /places?min_rating=4.0          | Filter by rating                    |
| GET    | /places?search=biryani          | Search by name/description          |
| GET    | /places/{id}                    | Get a single place                  |
| GET    | /places/{id}/reviews            | Get reviews for a place             |
| POST   | /places/{id}/reviews            | Submit a review                     |
| GET    | /categories                     | List all categories                 |
| GET    | /stats                          | Dashboard summary stats             |

## Database Tables
- **categories** — Food, Hangout, Tourist, Essentials
- **places** — name, category, address, distance, avg_cost, rating, description
- **reviews** — linked to places, with reviewer name, text, rating
