INSERT INTO cars (carClass, price, capacity, name) VALUES
    (1, 1500, 2, 'Bugatti'),
    (2, 800, 4, 'Maybach'),
    (3, 480, 2, 'Porsche'),
    (4, 350, 4, 'Lexus'),
    (4, 300, 4, 'Tesla'),
    (4, 285, 4, 'Jaguar'),
    (5, 200, 4, 'Ford'),
    (5, 185, 4, 'Honda'),
    (6, 100, 4, 'Skoda'),
    (6, 90, 4, 'Hyundai');

-- Admin password: admin
-- User  password: user
INSERT INTO users (email, name, surname, password, isAdmin) VALUES
    ('admin@example.com', 'Admin', 'Adminovich', 
    '$argon2id$v=19$m=65536,t=3,p=4$L/zdZeZbUgw7FVQBU3Ob9g$CIz0BUlERwmCeKhO/IK4oRFCNStqBrxYzoqNjSc01O4', TRUE),
    ('user1@example.com', 'Pyotr', 'Novikov', 
    '$argon2id$v=19$m=65536,t=3,p=4$Iho8i4xAWtjahDO70/sJYw$xagc7c4SjBt+mZ19PsLdX+q7XZaqSB0HJAmkEPeCtqI', FALSE),
    ('user2@example.com', 'Sergei', 'Novikov', 
    '$argon2id$v=19$m=65536,t=3,p=4$J6d2FKqciAq1ge/mAxaubA$KRJ2K2+ITyxMIiJ6+9dLkELVpLZx57kQP06XRIig0dY', FALSE),
    ('user3@example.com', 'Andrey', 'Kolmogorov', 
    '$argon2id$v=19$m=65536,t=3,p=4$mQb1M4P+QriojNSNU7OD0Q$tsik2hGDTZgDbF/eCIO1nmZygCSxbEMKydeO01Zyyzk', FALSE),
    ('user4@example.com', 'Mikhail', 'Tal', 
    '$argon2id$v=19$m=65536,t=3,p=4$Iho8i4xAWtjahDO70/sJYw$xagc7c4SjBt+mZ19PsLdX+q7XZaqSB0HJAmkEPeCtqI', FALSE),
    ('user5@example.com', 'Garry', 'Kasparov', 
    '$argon2id$v=19$m=65536,t=3,p=4$J6d2FKqciAq1ge/mAxaubA$KRJ2K2+ITyxMIiJ6+9dLkELVpLZx57kQP06XRIig0dY', FALSE),
    ('user6@example.com', 'Anatoly', 'Karpov', 
    '$argon2id$v=19$m=65536,t=3,p=4$mQb1M4P+QriojNSNU7OD0Q$tsik2hGDTZgDbF/eCIO1nmZygCSxbEMKydeO01Zyyzk', FALSE),
    ('user7@example.com', 'Bobby', 'Fischer', 
    '$argon2id$v=19$m=65536,t=3,p=4$Iho8i4xAWtjahDO70/sJYw$xagc7c4SjBt+mZ19PsLdX+q7XZaqSB0HJAmkEPeCtqI', FALSE),
    ('user8@example.com', 'Magnus', 'Carlsen', 
    '$argon2id$v=19$m=65536,t=3,p=4$J6d2FKqciAq1ge/mAxaubA$KRJ2K2+ITyxMIiJ6+9dLkELVpLZx57kQP06XRIig0dY', FALSE),
    ('user9@example.com', 'Anatoly', 'Karpov', 
    '$argon2id$v=19$m=65536,t=3,p=4$mQb1M4P+QriojNSNU7OD0Q$tsik2hGDTZgDbF/eCIO1nmZygCSxbEMKydeO01Zyyzk', FALSE);
    
INSERT INTO rents (carId, userId, dateStart, dateEnd, status) VALUES
    (3, 2,  '2023-05-01 15:00:00', '2024-05-01 15:00:00', 'Inactive'),
    (1, 3,  '2024-07-01 13:00:00', '2024-10-10 16:30:00', 'Inactive'),
    (4, 4,  '2024-05-01 15:00:00', '2024-05-10 15:00:00', 'Inactive'),
    (2, 5,  '2025-05-01 13:00:00', '2025-05-10 16:30:00', 'Inactive'),
    (5, 6,  '2026-01-01 15:00:00', '2026-01-02 12:00:00', 'Inactive'),
    (9, 7,  '2026-03-01 15:00:00', '2026-03-25 15:00:00', 'Inactive'),
    (8, 8,  '2026-04-01 12:00:00', '2026-04-18 12:00:00', 'Active'),
    (6, 9,  '2026-04-01 14:00:00', '2026-04-19 17:00:00', 'Active'),
    (7, 10, '2026-04-01 17:25:00', '2026-04-27 17:25:00', 'Active'),
    (10, 2, '2026-04-01 17:25:00', '2026-05-10 17:20:00', 'Active');
