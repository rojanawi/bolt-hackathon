/*
  # Create characters and battles tables

  1. New Tables
    - characters
      - id (uuid, primary key)
      - user_id (references auth.users)
      - name (text)
      - health (integer)
      - attack (integer)
      - defense (integer)
      - created_at (timestamp)
    - battles
      - id (uuid, primary key)
      - character1_id (references characters)
      - character2_id (references characters)
      - winner_id (references characters)
      - created_at (timestamp)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users
*/

CREATE TABLE characters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  name text NOT NULL,
  health integer NOT NULL DEFAULT 100,
  attack integer NOT NULL DEFAULT 10,
  defense integer NOT NULL DEFAULT 5,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE battles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  character1_id uuid REFERENCES characters NOT NULL,
  character2_id uuid REFERENCES characters NOT NULL,
  winner_id uuid REFERENCES characters,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE battles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own characters"
  ON characters
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own characters"
  ON characters
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can read battles they participated in"
  ON battles
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM characters
      WHERE (characters.id = battles.character1_id OR characters.id = battles.character2_id)
      AND characters.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create battles with their characters"
  ON battles
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM characters
      WHERE characters.id = battles.character1_id
      AND characters.user_id = auth.uid()
    )
  );