# Around the Corner 🗺️
A DBMS project to discover food, hangout, tourist, and essential spots near college.

https://avnikashyap08.github.io/around-the-corner/

## Project Structure
```
around-the-corner/
├── schema.sql      
├── main.py    
├── index.html      
├── requirements.txt
└── README.md
```
## Database Tables
- **categories** — Food, Hangout, Tourist, Essentials
- **places** — name, category, address, distance, avg_cost, rating, description
- **reviews** — linked to places, text, rating

python -m uvicorn main:app --reload
