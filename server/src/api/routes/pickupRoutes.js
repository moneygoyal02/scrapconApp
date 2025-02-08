import express from "express";
import multer from "multer";
import { protect, vendorOnly } from "../../middleware/authMiddleware.js";
import {
  requestPickup,
  getVendorPickups,
  getCustomerPickups,
  updatePickupStatus,
} from "../controllers/pickupController.js";

const router = express.Router();

// Use in-memory storage instead of saving to disk
const storage = multer.memoryStorage();
const upload = multer({ storage });

// The "scrapImage" file will now be available as req.file.buffer
router.post("/request", protect, upload.single("scrapImage"), requestPickup);
router.get("/vendor", protect, vendorOnly, getVendorPickups);
router.get("/customer", protect, getCustomerPickups);
router.put("/:pickupId/status", protect, vendorOnly, updatePickupStatus);

export default router;
