import mongoose from "mongoose"

const pickupItemSchema = new mongoose.Schema({
  category: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "ScrapCategory",
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
  },
  unit: {
    type: String,
    required: true,
  },
})

const pickupSchema = new mongoose.Schema(
  {
    customer: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    vendor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Vendor",
      required: true,
    },
    status: {
      type: String,
      enum: ["requested", "accepted", "completed", "cancelled"],
      default: "requested",
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
    items: [pickupItemSchema],
    totalAmount: {
      type: Number,
      default: 0,
    },
    notes: String,
    image: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  },
)

export const Pickup = mongoose.model("Pickup", pickupSchema)

