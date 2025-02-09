import { Bid } from "../../models/Bid.js";
import { BidAmount } from "../../models/BidsAmount.js";
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

// Create a new bid amount entry
export const createBidAmount = async (req, res, next) => {
  try {
    const { vendor, bid, highestBid } = req.body;
    // Assume the authenticated user is the customer placing the bid
    const customer = req.user._id;

    // Find the current highest bid for the given bid
    const currentHighestBidDoc = await BidAmount.findOne({ bid }).sort({ highestBid: -1 }).exec();

    // If there's an existing bid and the new bid is not higher, throw an error
    if (currentHighestBidDoc && highestBid <= currentHighestBidDoc.highestBid) {
      res.status(400);
      throw new Error(
        `Your bid must be higher than the current highest bid of ${currentHighestBidDoc.highestBid}`
      );
    }

    // Create and save the new bid amount
    const newBidAmount = new BidAmount({
      customer,
      vendor,
      bid,
      highestBid,
    });

    const savedBidAmount = await newBidAmount.save();

    res.status(201).json({
      success: true,
      bidAmount: savedBidAmount,
    });
  } catch (error) {
    next(error);
  }
};


// Get all bid amount entries
export const getAllBidAmounts = async (req, res, next) => {
  try {
    const bidAmounts = await BidAmount.find()
      .populate({
        path: 'customer',
        select: 'name email phone'
      })
      .populate({
        path: 'vendor',
        select: 'businessName phone'
      })
      .populate({
        path: 'bid',
        select: 'scheduledDate image'
      })
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: bidAmounts.length,
      bidAmounts,
    });
  } catch (error) {
    next(error);
  }
};

// Get a single bid amount entry by ID
export const getBidAmount = async (req, res, next) => {
  try {
    const bidAmount = await BidAmount.findById(req.params.id)
      .populate({
        path: 'customer',
        select: 'name email phone'
      })
      .populate({
        path: 'vendor',
        select: 'businessName phone'
      })
      .populate({
        path: 'bid',
        select: 'scheduledDate image'
      });

    if (!bidAmount) {
      res.status(404);
      throw new Error("Bid amount not found");
    }

    res.status(200).json({
      success: true,
      bidAmount,
    });
  } catch (error) {
    next(error);
  }
};

// Update a bid amount entry (for example, to update the highest bid)
export const updateBidAmount = async (req, res, next) => {
  try {
    const bidAmount = await BidAmount.findById(req.params.id);

    if (!bidAmount) {
      res.status(404);
      throw new Error("Bid amount not found");
    }

    bidAmount.highestBid = req.body.highestBid ?? bidAmount.highestBid;
    

    const updatedBidAmount = await bidAmount.save();

    res.status(200).json({
      success: true,
      bidAmount: updatedBidAmount,
    });
  } catch (error) {
    next(error);
  }
};

