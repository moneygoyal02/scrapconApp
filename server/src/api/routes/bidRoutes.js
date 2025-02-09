import express from "express";
import multer from "multer";
import { protect, vendorOnly } from "../../middleware/authMiddleware.js";
import { placeBid, getAllBids,getAllBidswp } from "../controllers/bidController.js";

const router = express.Router();

const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    // Accept images only
    if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
      return cb(new Error("Only image files are allowed!"), false);
    }
    cb(null, true);
  },
}).single("bidImage");

const uploadMiddleware = (req, res, next) => {
  upload(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      // A Multer error occurred when uploading
      res.status(400).json({ message: `Upload error: ${err.message}` });
    } else if (err) {
      // An unknown error occurred
      res.status(400).json({ message: `Unknown error: ${err.message}` });
    } else {
      // Everything went fine
      next();
    }
  });
};

router.post("/placeBid", protect, uploadMiddleware, placeBid);

router.get("/getAll", protect, getAllBids);
router.get("/getAllwp", getAllBidswp);
export default router;
