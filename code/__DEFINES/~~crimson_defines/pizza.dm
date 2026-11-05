
#define PIZZA_TOPPING_ICON 'modular_darkpack/modules/pizzeria/icons/pizza_toppings.dmi'

#define PIZZA_SIDE_WHOLE "whole"
#define PIZZA_SIDE_LEFT "left"
#define PIZZA_SIDE_RIGHT "right"

/// Most toppings a single pizza can hold (keeps overlay count sane)
#define PIZZA_MAX_TOPPINGS 30
/// How far from the pizza's center (in pixels) a topping may sit
#define PIZZA_TOPPING_RADIUS 11
/// Toppings needed for a "whole pizza" topping to count as fully covered
#define PIZZA_WHOLE_AMOUNT 6
/// Toppings needed for a "half pizza" topping to count as fully covered
#define PIZZA_HALF_AMOUNT 3
/// Pixels either side of the middle line that are forgiven on half toppings
#define PIZZA_HALF_DEADZONE 1
/// How long a customer waits before giving up
#define PIZZA_ORDER_PATIENCE (4 MINUTES)
#define PIZZA_BASE_PAY 20
/// How far from the customer spot we look for an NPC to take an order from
#define PIZZA_CUSTOMER_RANGE 4
/// Max simultaneous customers per counter
#define PIZZA_MAX_CUSTOMERS 3
/// Percent chance per counter process tick to pull in a new customer
#define PIZZA_ORDER_CHANCE 25
/// Servings of each topping a new station starts with
#define PIZZA_STOCK_START 40
/// Most servings of one topping a station can hold
#define PIZZA_STOCK_MAX 80
/// Servings in a fresh box of toppings
#define PIZZA_BOX_USES 40
