import { Bid } from "../../models/Bid.js";
import { User } from "../../models/User.js";
import { UserAddress } from "../../models/UserAddress.js";
import { uploadImage } from "../../services/cloudinaryService.js";

export const placeBid = async (req, res, next) => {
  try {
    const { scheduledDate, items } = req.body;
    
    // Check if file exists in the request
    if (!req.file || !req.file.buffer) {
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

    // Upload the image to Cloudinary
    let imageUrl;
    try {
      imageUrl = await uploadImage(req.file);
    } catch (error) {
      console.error("Image upload error:", error);
      res.status(400);
      throw new Error("Failed to upload image");
    }

    // Create and save the new bid
    const bid = new Bid({
      customer: customer._id,
      scheduledDate,
      address: address._id,
      items,
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

export const getAllBids = async (req, res, next) => {
  try {
    // Find all bids and populate customer and address details
    const bids = await Bid.find()
      .populate({
        path: 'customer',
        select: 'name email phone' // Select the fields you want to include
      })
      .populate({
        path: 'address',
        select: 'street city state zipCode' // Select the fields you want to include
      })
      .sort({ createdAt: -1 }); // Sort by newest first

    res.status(200).json({
      success: true,
      count: bids.length,
      bids: bids
    });
  } catch (error) {
    next(error);
  }
};

export const getAllBidswp = async (req, res, next) => {
  try {
    // Find all bids where isLive is true and populate customer and address details
    const bids = await Bid.find({ isLive: true })
      .populate({
        path: 'customer',
        select: 'name email phone' // Select the fields you want to include
      })
      .populate({
        path: 'address',
        select: 'street city state zipCode' // Select the fields you want to include
      })
      .sort({ createdAt: -1 }); // Sort by newest first

    res.status(200).json({
      success: true,
      count: bids.length,
      bids: bids
    });
  } catch (error) {
    next(error);
  }
};

