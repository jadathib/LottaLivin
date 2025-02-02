/*
  # Create posts table for travel blog

  1. New Tables
    - `posts`
      - `id` (uuid, primary key)
      - `title` (text)
      - `location` (text)
      - `date` (text)
      - `author` (text)
      - `image` (text)
      - `excerpt` (text)
      - `likes` (integer)
      - `comments` (integer)
      - `category` (text)
      - `created_at` (timestamptz)
      - `user_id` (uuid, foreign key to auth.users)

  2. Security
    - Enable RLS on `posts` table
    - Add policies for:
      - Anyone can read posts
      - Authenticated users can create their own posts
      - Users can update and delete their own posts
*/

CREATE TABLE posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  location text NOT NULL,
  date text NOT NULL,
  author text NOT NULL,
  image text NOT NULL,
  excerpt text NOT NULL,
  likes integer DEFAULT 0,
  comments integer DEFAULT 0,
  category text,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can read posts"
  ON posts
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can create posts"
  ON posts
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts"
  ON posts
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts"
  ON posts
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);