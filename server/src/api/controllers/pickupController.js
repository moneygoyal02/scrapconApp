import { Pickup } from "../../models/Pickup.js"
import { User } from "../../models/User.js"
import { Vendor } from "../../models/Vendor.js"
import { UserAddress } from "../../models/UserAddress.js"
import { uploadImage } from "../../services/cloudinaryService.js"

export const requestPickup = async (req, res, next) => {
  try {
    const { vendorId, scheduledDate, items, notes } = req.body

    if (!req.file) {
      res.status(400)
      throw new Error("Scrap image is required")
    }

    // Parse items if it's a string
    let parsedItems = items
    if (typeof items === "string") {
      try {
        parsedItems = JSON.parse(items)
      } catch (error) {
        res.status(400)
        throw new Error("Invalid items format")
      }
    }

    const customer = await User.findById(req.user._id)
    if (!customer) {
      res.status(404)
      throw new Error("Customer not found")
    }

    const vendor = await Vendor.findById(vendorId)
    if (!vendor) {
      res.status(404)
      throw new Error("Vendor not found")
    }

    const address = await UserAddress.findOne({ user: customer._id })
    if (!address) {
      res.status(400)
      throw new Error("Customer address not found")
    }

    // Upload image to Cloudinary
    const imageUrl = await uploadImage(req.file)

    const pickup = new Pickup({
      customer: customer._id,
      vendor: vendor._id,
      scheduledDate,
      address: address._id,
      items: parsedItems,
      notes,
      image: imageUrl,
    })

    const savedPickup = await pickup.save()

    res.status(201).json({
      message: "Pickup request created successfully",
      pickup: savedPickup,
    })
  } catch (error) {
    next(error)
  }
}

export const getVendorPickups = async (req, res, next) => {
  try {
    const pickups = await Pickup.find({ vendor: req.user._id })
      .populate("customer", "name email phone")
      .populate("address")
      .sort({ createdAt: -1 })

    res.json(pickups)
  } catch (error) {
    next(error)
  }
}

export const getCustomerPickups = async (req, res, next) => {
  try {
    const pickups = await Pickup.find({ customer: req.user._id })
      .populate("vendor", "businessName phone")
      .populate("address")
      .sort({ createdAt: -1 })

    res.json(pickups)
  } catch (error) {
    next(error)
  }
}

export const updatePickupStatus = async (req, res, next) => {
  try {
    const { pickupId } = req.params
    const { status } = req.body

    const pickup = await Pickup.findById(pickupId)
    if (!pickup) {
      res.status(404)
      throw new Error("Pickup not found")
    }

    if (pickup.vendor.toString() !== req.user._id.toString()) {
      res.status(403)
      throw new Error("Not authorized to update this pickup")
    }

    pickup.status = status
    const updatedPickup = await pickup.save()

    res.json({
      message: "Pickup status updated successfully",
      pickup: updatedPickup,
    })
  } catch (error) {
    next(error)
  }
}

