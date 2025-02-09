import mongoose from "mongoose";

const BidSchema = new mongoose.Schema(
  {
    customer: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    scheduledDate: {
      type: Date,
      required: true,
    },
    address: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "UserAddress",
      required: true,
    },
    category: {
      type: String,
      required: true,
    },
    quantity: {
        type: Number,
        required: true,
        },
        scrapquality: {
            type: Number,
            required: true,
            },
    isLive: {
      type: Boolean,
      default: true,
    },
    image: {
      type: String,
      required: true,
    },
    amount: {
      type: Number,
      required: true,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

export const Bid = mongoose.model("Bid", BidSchema);
