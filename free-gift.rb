FREEBIE_PRODUCT_1_ID = 4596968751191
CART_TOTAL_FOR_DISCOUNT_APPLIED = Money.new(cents: 15000)
DISCOUNT_MESSAGE = "Complimentary Kiss by a Rose Candle for orders $150+"

freebie_in_cart = false
cart_price_exceeds_discounted_freebie_amount = false
cost_of_freebie = Money.zero


Input.cart.line_items.select do |line_item|
  product = line_item.variant.product
  if product.id == FREEBIE_PRODUCT_1_ID
    freebie_in_cart = true
    cost_of_freebie = line_item.line_price
  end
end


if freebie_in_cart
  cart_subtotal_minus_freebie_cost = Input.cart.subtotal_price - cost_of_freebie
  if cart_subtotal_minus_freebie_cost >= CART_TOTAL_FOR_DISCOUNT_APPLIED
    cart_price_exceeds_discounted_freebie_amount = true
  end
end


was_discount_applied = false
if cart_price_exceeds_discounted_freebie_amount
  Input.cart.line_items.each do |item|
    if item.variant.product.id == FREEBIE_PRODUCT_1_ID && was_discount_applied == false
      if item.quantity > 1
        new_line_item = item.split(take: 1)
        new_line_item.change_line_price(Money.zero, message: DISCOUNT_MESSAGE)
        Input.cart.line_items << new_line_item
        next
      else
        item.change_line_price(Money.zero, message: DISCOUNT_MESSAGE)
      end
    end
  end
end

Output.cart = Input.cart
