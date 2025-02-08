import express from "express"
import multer from "multer"
import { protect, vendorOnly } from "../../middleware/authMiddleware.js"
import {
  requestPickup,
  getVendorPickups,
  getCustomerPickups,
  updatePickupStatus,
} from "../controllers/pickupController.js"

const router = express.Router()

const upload = multer({ dest: "uploads/" })

router.post("/request", protect, upload.single("scrapImage"), requestPickup)
router.get("/vendor", protect, vendorOnly, getVendorPickups)
router.get("/customer", protect, getCustomerPickups)
router.put("/:pickupId/status", protect, vendorOnly, updatePickupStatus)

export default router

