import { v2 as cloudinary } from "cloudinary"
import { config } from "../config/index.js"

cloudinary.config({
  cloud_name: config.cloudinary.cloudName,
  api_key: config.cloudinary.apiKey,
  api_secret: config.cloudinary.apiSecret,
})

export const uploadImage = async (file) => {
  try {
    console.log("Uploading image to Cloudinary...")
    const result = await cloudinary.uploader.upload(file.path, {
      folder: "scrapcon_pickups",
    })
    return result.secure_url
  } catch (error) {
    console.error("Error uploading image to Cloudinary:", error)
    throw new Error("Failed to upload image")
  }
}

