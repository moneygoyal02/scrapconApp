import { Bid } from "../../models/Bid.js";
import { User } from "../../models/User.js";
import { UserAddress } from "../../models/UserAddress.js";
import { uploadImage } from "../../services/cloudinaryService.js";

export const placeBid = async (req, res, next) => {
  try {
    const { scheduledDate, items } = req.body;
    console.log(req.files);
    console.log(req.body);
    console.log("Request headers:", req.headers)

    // Ensure an image file is attached (named "bidImage" in the form-data)
    if (!req.file) {
      res.status(400);
      throw new Error("Bid image is required");
    }

    // Find the authenticated user
    const customer = await User.findById(req.user._id);
    if (!customer) {
      res.status(404);
      throw new Error("Customer not found");
    }

    // Retrieve the customer's address
    const address = await UserAddress.findOne({ user: customer._id });
    if (!address) {
      res.status(400);
      throw new Error("Customer address not found");
    }

    // Upload the image to Cloudinary (using in-memory file from multer)
    const imageUrl = await uploadImage(req.file);

    // Create and save the new bid
    const bid = new Bid({
      customer: customer._id,
      scheduledDate,
      address: address._id,
      items, // Ensure items is a string (if needed, adjust conversion here)
      image: imageUrl,
    });

    const savedBid = await bid.save();

    res.status(201).json({
      message: "Bid placed successfully",
      bid: savedBid,
    });
  } catch (error) {
    next(error);
  }
};
