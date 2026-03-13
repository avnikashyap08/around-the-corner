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

CREATE TABLE places (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    address TEXT NOT NULL,
    distance_km NUMERIC(5, 2) NOT NULL,
    avg_cost INTEGER,
    rating NUMERIC(2, 1) CHECK (rating >= 0 AND rating <= 5),
    description TEXT,
    is_open BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    place_id INTEGER REFERENCES places(id) ON DELETE CASCADE,
    review_text TEXT,
    rating NUMERIC(2, 1) CHECK (rating >= 0 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO places (name, category_id, address, distance_km, avg_cost, rating, description) VALUES
('Rolling Crunchys Cafe', 1, 'Saheed Nagar', 12.5 , 400 , 4.7 ,'Very aesthetic and cozy place. Their rolling crunchys chicken salad is just one of a kind. love love love this place'),
('The Bombai Cafe', 1, 'Chandrashekharpur', 7.1 , 650 , 4.2 ,'Try their affogato and crispy thread chicken.'),
('Terra Rosso', 1, 'Janpath Road, Master Canteen', 14.0 , 600 , 4.0 , 'Most authetic pizzas in all of bbsr.'),
('Umami Cha', 1, 'Mahavir Nagar, Sishu Vihar', 4.3 , 500 , 4.0 , 'Best korean food in town.'),
('Urban Canteen', 1, 'Infocity', 3.9 , 400 , 4.5 , 'Best place for North Indian. Chicken Butter masala is a must try.'),
('Nexus Esplanade', 4, 'Rasulgarh', 14.2 , 0 , 4.5 , 'Large shopping mall with retail stores, food court, and cinema. Popular spot for shopping and essentials.'),
('Utkal Galleria', 4, 'BMC', 15.2 , 0 , 3.5 , 'Modern shopping complex with fashion outlets, restaurants, and daily utility stores.'),
('V-Mart', 4, 'Patia', 2.6 , 0 , 3.5 , 'Affordable department store offering clothing, household goods, and daily essentials.'),
('BMC Bhawani Mall', 4, 'Saheed Nagar', 12.7 , 0 , 3.8 , 'City mall with multiple retail outlets and convenience stores for everyday needs and has INOX movie theater.'),
('Reliance Smart', 4, 'Patia', 3.7 , 0 , 4.2 , 'Supermarket chain providing groceries, fresh produce, and household essentials.'),
('Buddha Jayanti Park', 2, 'Niladri Vihar', 6.5, 0, 4.4, 'the best park ever in Bhubaneswar. Best spot for all age groups. Quite greenish atmosphere with friendly nature.'),
('Pandav Bakhra', 2, 'Banki', 7.8, 300, 4.3, 'Historic rock formations linked to mythology. A calm place for exploring and relaxing with scenic surroundings.'),
('Sikharchandi Hills', 2, 'Patia', 9.2, 0, 4.6, 'Popular hilltop hangout for trekking, sunsets, and city views. Loved by students and bikers.'),
('Barunei Hills', 2, 'Khurda', 28.5, 200, 4.5, ' It is one of the popular tourist attractions of the Khordha district for its scenic beauty and pleasant atmosphere. Do visit this place with your friends and family, and do not to forget the trek trail through the wilderness.'),
('Deras Dam', 2, 'Barapita', 22.0, 200, 4.6, 'This place located in outskirts of bhubaneswar and this place is full of nature beauty. Most of the people goes to this place for picnic.'),
('Ram Mandir', 3, 'Janpath Road, Kharvela Nagar', 4.2 , 0, 4.6, 'Famous temple dedicated to Lord Rama in the heart of Bhubaneswar. A peaceful and popular spiritual spot.'),
('Dhauli Giri', 3, 'Dhauli Hills, Uttara', 8.5, 50, 4.7, 'Historic hill known for the Dhauli Shanti Stupa where Emperor Ashoka embraced Buddhism after the Kalinga war.'),
('Khandagiri - Udayagiri Caves', 3, 'Khandagiri', 7.5, 20, 4.6, 'These ancient caves are carved and tunnelled to create multi-storied apartments for the Jain monks. They were probably carved in the 1st century from a single massive boulder. It is worth the time to visit here, the surrounding views are stunning.'),
('Odisha State Museum', 3, 'Kalpana Square, Lewis Road', 5.0, 30, 4.4, 'Museum showcasing Odisha rich cultural heritage including sculptures, manuscripts, and historical artefacts.'),
('Lingaraj Temple', 3, 'Old Town', 6.2, 0, 4.8, 'This is the best museum in Odisha. They have many educational and historical resources. Ticket price is also very low.');

INSERT INTO reviews (place_id, review_text, rating) VALUES
(1,   'Best value thali I have had. Fill up for under ₹100!', 4.5),
(1,   'Dal is amazing. A bit crowded at lunch though.',        4.0),
(2,   'The biryani is absolutely worth every rupee.',          5.0),
(5,     'You have to try the pani puri. Life-changing.',         5.0),
(6,   'Wi-Fi is solid and staff is friendly. My go-to cafe.',  4.5),
(10,   'Beautiful fort, great for photography. Go at sunrise.', 5.0),
(13,  'Open at 3 AM too. Saved me during exam week.',          4.5);


SELECT * FROM places;