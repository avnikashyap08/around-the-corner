-- ============================================
-- Around the Corner - PostgreSQL Schema
-- ============================================

CREATE DATABASE around_the_corner;
\c around_the_corner;

-- Categories Table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    icon VARCHAR(10)
);

INSERT INTO categories (name, icon) VALUES
    ('Food', '🍽️'),
    ('Hangout', '☕'),
    ('Tourist', '🏛️'),
    ('Essentials', '🏪');

-- Places Table
CREATE TABLE places (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    address TEXT NOT NULL,
    distance_km NUMERIC(5, 2) NOT NULL,   -- distance from college in km
    avg_cost INTEGER,                      -- avg cost per person in ₹
    rating NUMERIC(2, 1) CHECK (rating >= 0 AND rating <= 5),
    description TEXT,
    is_open BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    place_id INTEGER REFERENCES places(id) ON DELETE CASCADE,
    reviewer_name VARCHAR(80) NOT NULL,
    review_text TEXT,
    rating NUMERIC(2, 1) CHECK (rating >= 0 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Sample Data
-- ============================================

INSERT INTO places (name, category_id, address, distance_km, avg_cost, rating, description) VALUES
-- Food
('Sharma Ji Ka Dhaba',       1, 'MG Road, Near Gate 2',          0.3,  80,  4.2, 'Classic north Indian thali, very student-friendly prices.'),
('The Biryani House',        1, 'Linking Road, Opp. Bank',        0.7, 150,  4.5, 'Best biryani in the area. Try the chicken dum biryani.'),
('Dosa Plaza',               1, 'Station Road, Ground Floor',     1.1,  60,  3.9, 'South Indian fast food. Affordable masala dosa and idlis.'),
('Pizza Port',               1, 'Mall Road, Food Court',          1.5, 250,  4.0, 'Quick pizza and pasta. Good for group outings.'),
('Chaat Corner',             1, 'College Lane, Outside Gate 1',   0.1,  40,  4.7, 'Legendary pani puri and bhel puri stall. A hostel favourite.'),

-- Hangout
('Brewed Awakenings Cafe',   2, 'Park Street, 1st Floor',         0.9, 200,  4.6, 'Cozy cafe with good Wi-Fi. Great for assignments and group study.'),
('The Adda',                 2, 'Canal Road, Near Signal',        1.2, 180,  4.3, 'Board games, chai, and vibes. Perfect hangout for evenings.'),
('Green Patch Garden',       2, 'Riverside, Public Park',         0.5,   0,  4.4, 'Free public garden by the river. Nice for walks and chilling.'),
('Retro Game Zone',          2, 'Metro Mall, 2nd Floor',          2.0, 100,  3.8, 'Arcade games and pool tables. Fun for weekends.'),

-- Tourist
('Old City Fort',            3, 'Fort Road, Heritage Zone',       3.5,  30,  4.8, 'Historic 18th century fort. Must visit if you are new to the city.'),
('Lakeside Temple',          3, 'Lake Boulevard, East Side',      2.8,   0,  4.5, 'Peaceful temple by the lake. Famous for sunrise views.'),
('Art District Museum',      3, 'Culture Lane, City Centre',      4.0,  50,  4.1, 'Modern art and local heritage exhibits. Student discount available.'),

-- Essentials
('24x7 Medical Store',       4, 'College Road, Opp. Hostel A',    0.2,   0,  4.0, 'Always open pharmacy. Stocks all basic medicines and toiletries.'),
('SuperMart',                4, 'Main Market, Block 3',           0.6,   0,  3.7, 'Grocery and stationery. Reasonable prices, accepts UPI.'),
('Quick Xerox & Print',      4, 'Library Lane, Ground Floor',     0.4,   0,  4.3, 'Fast printing and binding. Open till 10 PM on weekdays.'),
('SBI ATM',                  4, 'Gate 1, Campus Boundary',        0.1,   0,  3.5, 'Nearest ATM to the campus. Usually no queue in mornings.');

-- Sample Reviews
INSERT INTO reviews (place_id, reviewer_name, review_text, rating) VALUES
(1,  'Riya S.',     'Best value thali I have had. Fill up for under ₹100!', 4.5),
(1,  'Harsh P.',    'Dal is amazing. A bit crowded at lunch though.',        4.0),
(2,  'Ananya M.',   'The biryani is absolutely worth every rupee.',          5.0),
(5,  'Dev K.',      'You have to try the pani puri. Life-changing.',         5.0),
(6,  'Sneha R.',    'Wi-Fi is solid and staff is friendly. My go-to cafe.',  4.5),
(10, 'Arjun T.',    'Beautiful fort, great for photography. Go at sunrise.', 5.0),
(13, 'Meera J.',    'Open at 3 AM too. Saved me during exam week.',          4.5);
