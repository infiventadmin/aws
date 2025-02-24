import pkg from 'pg';
import dotenv from "dotenv";
dotenv.config();

const { Client } = pkg;

export const handler = async () => {
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
    const res = await client.query('SELECT * FROM users');
    return {
      statusCode: 200,
      body: JSON.stringify(res.rows),
    };
  } catch (error) {
    console.error('DB Connection Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Database query failed' }),
    };
  } finally {
    await client.end();
  }
};
