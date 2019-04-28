class(c1, 'Web User', f).
class(c2, 'Customer', f).
class(c3, 'Account', f).
class(c4, 'Shopping Cart', f).
class(c5, 'LineItem', f).
class(c6, 'Order', f).
class(c7, 'Payment', f).
class(c8, 'Product', f).
class(c9, 'OrderStatus', f).
class(c10, 'String', f).
class(c11, 'Address', f).
class(c12, 'Phone', f).
class(c13, 'Date', f).
class(c14, 'UserState', f).
class(c15, 'Real', f).
class(c16, 'Supplier', f).

attribute(a1, 'login_id', c10, c1).
attribute(a2, 'password', c10, c1).
attribute(a3, 'attribute11', int, c1).
attribute(a4, 'id', c10, c2).
attribute(a5, 'address', c11, c2).
attribute(a6, 'phone', c12, c2).
attribute(a7, 'email', c10, c2).
attribute(a8, 'id', c10, c3).
attribute(a9, 'billing_address', c11, c3).
attribute(a10, 'is_closed', boolean, c3).
attribute(a11, 'open', c13, c3).
attribute(a12, 'closed', c13, c3).
attribute(a13, 'created', c13, c4).
attribute(a14, 'quantity', int, c5).
attribute(a15, 'price', float, c5).
attribute(a16, 'number', c10, c6).
attribute(a17, 'ordered', c13, c6).
attribute(a18, 'shipped', c13, c6).
attribute(a19, 'ship_to', c11, c6).
attribute(a20, 'status', c9, c6).
attribute(a21, 'total', c15, c6).
attribute(a22, 'id', c10, c7).
attribute(a23, 'paid', c13, c7).
attribute(a24, 'total', c15, c7).
attribute(a25, 'details', c10, c7).
attribute(a26, 'id', c10, c8).
attribute(a27, 'name', c10, c8).
attribute(a28, 'supplier', c16, c8).



association(s1, c8, c5).
association(s2, c3, c7).
association(s3, c5, c6).
association(s4, c7, c6).
association(s5, c1, c2).
association(s6, c4, c1).
association(s7, c2, c3).
association(s8, c4, c3).
association(s9, c3, c6).
association(s10, c4, c5).

rolename(r1, 'product', 'lineitem', s1).
rolename(r2, 'account', 'payment', s2).
rolename(r3, 'lineitem', 'order', s3).
rolename(r4, 'payment', 'order', s4).
rolename(r5, 'web user', 'customer', s5).
rolename(r6, 'shopping cart', 'web user', s6).
rolename(r7, 'customer', 'account', s7).
rolename(r8, 'shopping cart', 'account', s8).
rolename(r9, 'account', 'order', s9).
rolename(r10, 'line_item', 'lineitem', s10).

multiplicity(m1, c1, 1, 1, s5).
multiplicity(m2, c1, 0, 1, s6).
multiplicity(m3, c2, 1, 1, s5).
multiplicity(m4, c2, 1, 1, s7).
multiplicity(m5, c3, 1, n, s2).
multiplicity(m6, c3, 1, 1, s7).
multiplicity(m7, c3, 1, 1, s8).
multiplicity(m8, c3, 1, n, s9).
multiplicity(m9, c4, 1, 1, s6).
multiplicity(m10, c4, 1, 1, s8).
multiplicity(m11, c4, 1, n, s10).
multiplicity(m12, c5, 1, 1, s1).
multiplicity(m13, c5, 1, 1, s3).
multiplicity(m14, c5, 1, 1, s10).
multiplicity(m15, c6, 1, n, s3).
multiplicity(m16, c6, 1, n, s4).
multiplicity(m17, c6, 1, 1, s9).
multiplicity(m18, c7, 1, 1, s2).
multiplicity(m19, c7, 1, 1, s4).
multiplicity(m20, c8, 1, n, s1).


