import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import mongoose from "mongoose";
import { config } from "./config/index.js";
import { errorHandler } from "./middleware/errorHandler.js";
import { notFoundHandler } from "./middleware/notFoundHandler.js";
import userRoutes from "./api/routes/userRoutes.js";
import vendorRoutes from "./api/routes/vendorRoutes.js";
import pickupRoutes from "./api/routes/pickupRoutes.js";
import reviewRoutes from "./api/routes/reviewRoutes.js";
import scrapCategoryRoutes from "./api/routes/scrapCategoryRoutes.js";
import adminRoutes from "./api/routes/adminRoutes.js";
import { getAllUsers } from "./api/controllers/leaderboardController.js";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";
import { ImageAnnotatorClient } from "@google-cloud/vision";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Use JSON parser with an increased payload limit for image uploads
app.use(express.json({ limit: "10mb" }));
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

// Connect to MongoDB
mongoose
  .connect(config.databaseURL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((error) => console.error("MongoDB connection error:", error));

// Initialize the Google Cloud Vision client using environment variable credentials
const credentialsString = process.env.GOOGLE_CREDENTIALS;

if (!credentialsString) {
  throw new Error("GOOGLE_CREDENTIALS environment variable is not set.");
}
const credentials = JSON.parse(credentialsString);

const visionClient = new ImageAnnotatorClient({ credentials });

// Define the /detect endpoint
app.post("/detect", async (req, res, next) => {
  console.log("[POST] /detect");
  try {
    const base64Image = req.body.image;
    if (!base64Image) {
      return res.status(400).json({ error: "No image provided" });
    }

    // Convert the base64 image string to a buffer
    const imageBytes = Buffer.from(base64Image, "base64");
    const image = { content: imageBytes };

    // Use the Vision API to detect objects in the image
    const [response] = await visionClient.objectLocalization({ image });
    const objects = response.localizedObjectAnnotations;

    res.json({ objects });
  } catch (error) {
    console.error("Error in /detect:", error);
    next(error);
  }
});

// API Routes
app.use("/api/users", userRoutes);
app.use("/api/vendors", vendorRoutes);
app.use("/api/pickups", pickupRoutes);
app.use("/api/scrap-categories", scrapCategoryRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/reviews", reviewRoutes);
app.get("/api/leaderboard", getAllUsers);
app.get("/", (req, res) => {
  res.send("Server is running");
});

// Error handling middleware
app.use(notFoundHandler);
app.use(errorHandler);

const PORT = config.port || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
