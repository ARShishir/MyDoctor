-- Supabase (Postgres) schema for MyDoctor app

-- Table: users
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  email text UNIQUE,
  created_at timestamptz DEFAULT now()
);

-- Table: services (hospitals, clinics, pharmacies, diagnostics)
CREATE TABLE IF NOT EXISTS services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL,
  distance text,
  rating numeric DEFAULT 0,
  is_open boolean DEFAULT true,
  phone text,
  address text,
  open_hours text,
  color text, -- store as hex string like #FF2196F3
  icon text,
  created_at timestamptz DEFAULT now()
);

-- Table: medicines (user-specific schedules)
CREATE TABLE IF NOT EXISTS medicines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  medicine text NOT NULL,
  dosage text,
  time text, -- store as HH:MM
  frequency text,
  color text,
  taken boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Dummy data: users
INSERT INTO users (name, email) VALUES
  ('Demo User', 'demo@example.com')
ON CONFLICT (email) DO NOTHING;

-- Dummy data: services
-- Ensure `name` has a uniqueness constraint so ON CONFLICT (name) works
CREATE UNIQUE INDEX IF NOT EXISTS services_name_idx ON services (name);

INSERT INTO services (name, type, distance, rating, is_open, phone, address, open_hours, color, icon)
VALUES
  ('City Care Hospital', 'Hospital', '1.2 km', 4.5, true, '01712-345678', 'ধানমন্ডি, ঢাকা', '24/7', '#FF2196F3', 'local_hospital'),
  ('Lifeline Diagnostic Center', 'Diagnostic', '800 m', 4.2, true, '01712-987654', 'মিরপুর, ঢাকা', '8 AM - 10 PM', '#FF9C27B0', 'biotech'),
  ('Green Pharmacy', 'Pharmacy', '500 m', 4.6, true, '01712-111222', 'বনানী, ঢাকা', '8 AM - 11 PM', '#FF4CAF50', 'local_pharmacy')
ON CONFLICT (name) DO NOTHING;

-- Dummy data: medicines (for demo user)
INSERT INTO medicines (user_id, medicine, dosage, time, frequency, color, taken)
SELECT id, 'Napa 500mg', '১ ট্যাবলেট', '08:00', 'প্রতিদিন', '#FF2196F3', true FROM users WHERE email='demo@example.com' LIMIT 1
ON CONFLICT DO NOTHING;

-- NOTE ON ROW LEVEL SECURITY (RLS):
-- If you see `new row violates row-level security policy for table "profiles"`
-- it means RLS is enabled on that table and anonymous inserts are blocked.
-- Quick options:
-- 1) Disable RLS for the table (not recommended for production):
--    ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
-- 2) Create a permissive policy for anonymous inserts (better, but tailor for your app):
--    ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
--    CREATE POLICY "Allow anon insert" ON profiles FOR INSERT TO anon USING (true) WITH CHECK (true);
-- 3) Use the `service_role` key for server-side inserts (keeps RLS enabled).

