import express from "express"
import multer from "multer"
import { protect, vendorOnly } from "../../middleware/authMiddleware.js";
import { placeBid } from "../controllers/bidController.js"

const router = express.Router()

const storage = multer.memoryStorage()
const upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith("image/")) {
      cb(null, true)
    } else {
      cb(new Error("Not an image! Please upload an image."), false)
    }
  },
}).single("bidImage")

router.post(
  "/placeBid",
  protect,
  (req, res, next) => {
    upload(req, res, (err) => {
      if (err instanceof multer.MulterError) {
        // A Multer error occurred when uploading.
        return res.status(400).json({ message: `Multer uploading error: ${err.message}` })
      } else if (err) {
        // An unknown error occurred when uploading.
        return res.status(400).json({ message: `Unknown uploading error: ${err.message}` })
      }
      // Everything went fine.
      next()
    })
  },
  placeBid,
)

export default router

