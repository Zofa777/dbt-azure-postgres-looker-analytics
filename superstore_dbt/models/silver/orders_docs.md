{% docs cleaned_order_quantity %}

### Cleaned order quantity

This column represents the quantity of products  ordered after applying data-cleaning rules.

**Transformation rules:**
- Positive quantities remain unchanged
- Zero quantites are replaced with 1
- Negative quantities are replaced with 1

This transformation ensures that downstream analytics receive positive order quantities.

{% enddocs %}
