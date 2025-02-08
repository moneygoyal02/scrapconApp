import { v2 as cloudinary } from "cloudinary";
import streamifier from "streamifier";
import { config } from "../config/index.js";

// Configure Cloudinary with your credentials
cloudinary.config({
  cloud_name: config.cloudinary.cloudName,
  api_key: config.cloudinary.apiKey,
  api_secret: config.cloudinary.apiSecret,
});

export const uploadImage = async (file) => {
  try {
    console.log("Uploading image to Cloudinary...");

    // Create a promise that resolves with the upload result
    const result = await new Promise((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        { folder: "scrapcon_pickups" },
        (error, result) => {
          if (error) return reject(error);
          resolve(result);
        }
      );
      // Pipe the in-memory file buffer to the Cloudinary upload stream
      streamifier.createReadStream(file.buffer).pipe(uploadStream);
    });

    return result.secure_url;
  } catch (error) {
    console.error("Error uploading image to Cloudinary:", error);
    throw new Error("Failed to upload image");
  }
};
