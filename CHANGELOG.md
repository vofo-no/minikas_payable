# Changelog

## 0.1.5 (April 10, 2019)

* Add config block

## 0.1.4 (April 10, 2019)

* Controllers inherit from parent controller

## 0.1.3 (April 4, 2019)

* Add Pundit dependency.

## 0.1.2 (April 4, 2019)

* Fixed: Missing include Pundit in controller.

## 0.1.1 (April 4, 2019)

* New: ```payer#transfer_amount(amount)``` for explicit transfers (override unpaid).
* Change: ```payer#transfer``` (remove ```amount``` argument - always use unpaid)