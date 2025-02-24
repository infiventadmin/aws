import pkg from 'pg';
import dotenv from "dotenv";
dotenv.config();

const { Client } = pkg;

export const handler = async (event) => {
  const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    ssl: { rejectUnauthorized: false },
  });

  try {
    await client.connect();
    const { name, email } = JSON.parse(event.body);
    await client.query('INSERT INTO users (name, email) VALUES ($1, $2)', [name, email]);

    return { statusCode: 201, body: JSON.stringify({ message: "User added!" }) };
  } catch (error) {
    console.error("Database Error:", error);
    return { statusCode: 500, body: JSON.stringify({ error: "Failed to insert user." }) };
  } finally {
    await client.end();
  }
};
