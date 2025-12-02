// Benchmark file with many types to test ppx performance
// This file contains a mix of records, variants, polyvariants, and nested types

// ============================================================================
// Simple Records
// ============================================================================

@spice
type user = {
  id: int,
  name: string,
  email: string,
  active: bool,
}

@spice
type address = {
  street: string,
  city: string,
  state: string,
  zip: string,
  country: string,
}

@spice
type coordinates = {
  lat: float,
  lng: float,
  altitude: option<float>,
}

@spice
type timestamp = {
  seconds: int,
  nanos: int,
}

@spice
type metadata = {
  createdAt: timestamp,
  updatedAt: timestamp,
  version: int,
}

// ============================================================================
// Records with Optional Fields
// ============================================================================

@spice
type profile = {
  userId: int,
  displayName: string,
  bio: option<string>,
  avatarUrl: option<string>,
  website: option<string>,
  location: option<string>,
}

@spice
type settings = {
  theme: string,
  language: string,
  notifications: option<bool>,
  emailDigest: option<bool>,
  twoFactorEnabled: option<bool>,
}

@spice
type preferences = {
  darkMode: option<bool>,
  fontSize: option<int>,
  compactView: option<bool>,
  showAvatars: option<bool>,
  autoPlay: option<bool>,
}

// ============================================================================
// Nested Records
// ============================================================================

@spice
type company = {
  id: int,
  name: string,
  address: address,
  founded: int,
}

@spice
type employee = {
  id: int,
  user: user,
  company: company,
  department: string,
  title: string,
  salary: float,
}

@spice
type order = {
  id: int,
  customer: user,
  shippingAddress: address,
  billingAddress: address,
  total: float,
  metadata: metadata,
}

// ============================================================================
// Variants
// ============================================================================

@spice
type status =
  | Active
  | Inactive
  | Pending
  | Suspended
  | Deleted

@spice
type priority =
  | Low
  | Medium
  | High
  | Critical
  | Urgent

@spice
type httpMethod =
  | GET
  | POST
  | PUT
  | PATCH
  | DELETE
  | HEAD
  | OPTIONS

@spice
type responseCode =
  | OkResponse
  | Created
  | BadRequest
  | Unauthorized
  | Forbidden
  | NotFound
  | ServerError

// ============================================================================
// Variants with Payloads
// ============================================================================

@spice
type result_data =
  | Success(string)
  | Failure(string, int)
  | Pending
  | Cancelled(string)

@spice
type notification =
  | Email(string)
  | SMS(string)
  | Push(string, string)
  | InApp(int, string)

@spice
type payment =
  | CreditCard(string, string, int)
  | PayPal(string)
  | BankTransfer(string, string)
  | Crypto(string, string)

@spice
type event =
  | Click(int, int)
  | Scroll(int)
  | KeyPress(string)
  | MouseMove(int, int)
  | TouchStart(int, int)
  | TouchEnd(int, int)

// ============================================================================
// Polyvariants
// ============================================================================

@spice
type color = [
  | #Red
  | #Green
  | #Blue
  | #Yellow
  | #Purple
  | #Orange
  | #Black
  | #White
]

@spice
type size = [
  | #XS
  | #S
  | #M
  | #L
  | #XL
  | #XXL
]

@spice
type direction = [
  | #North
  | #South
  | #East
  | #West
  | #NorthEast
  | #NorthWest
  | #SouthEast
  | #SouthWest
]

@spice
type alignment = [
  | #Left
  | #Center
  | #Right
  | #Justify
  | #Top
  | #Middle
  | #Bottom
]

// ============================================================================
// Polyvariants with @spice.as
// ============================================================================

@spice
type statusCode = [
  | @spice.as("ok") #Ok
  | @spice.as("error") #Error
  | @spice.as("pending") #Pending
  | @spice.as("cancelled") #Cancelled
]

@spice
type logLevel = [
  | @spice.as("debug") #Debug
  | @spice.as("info") #Info
  | @spice.as("warn") #Warn
  | @spice.as("error") #Error
  | @spice.as("fatal") #Fatal
]

@spice
type environment = [
  | @spice.as("development") #Development
  | @spice.as("staging") #Staging
  | @spice.as("production") #Production
  | @spice.as("test") #Test
]

// ============================================================================
// Complex Nested Types
// ============================================================================

@spice
type blogPost = {
  id: int,
  title: string,
  content: string,
  author: user,
  status: status,
  tags: array<string>,
  metadata: metadata,
}

@spice
type comment = {
  id: int,
  postId: int,
  author: user,
  content: string,
  likes: int,
  replies: array<int>,
  metadata: metadata,
}

@spice
type category = {
  id: int,
  name: string,
  slug: string,
  description: option<string>,
  parentId: option<int>,
}

@spice
type product = {
  id: int,
  name: string,
  description: string,
  price: float,
  category: category,
  tags: array<string>,
  inStock: bool,
  metadata: metadata,
}

@spice
type cartItem = {
  product: product,
  quantity: int,
  customizations: option<array<string>>,
}

@spice
type cart = {
  id: int,
  userId: int,
  items: array<cartItem>,
  total: float,
  metadata: metadata,
}

// ============================================================================
// Generic Types
// ============================================================================

@spice
type wrapper<'a> = {
  data: 'a,
  timestamp: int,
}

@spice
type response<'a> = {
  success: bool,
  data: option<'a>,
  error: option<string>,
}

@spice
type paginated<'a> = {
  items: array<'a>,
  page: int,
  pageSize: int,
  totalItems: int,
  totalPages: int,
}

@spice
type keyValue<'k, 'v> = {
  key: 'k,
  value: 'v,
}

// ============================================================================
// Records with @spice.key
// ============================================================================

@spice
type apiUser = {
  @spice.key("user_id") userId: int,
  @spice.key("first_name") firstName: string,
  @spice.key("last_name") lastName: string,
  @spice.key("email_address") emailAddress: string,
  @spice.key("created_at") createdAt: string,
  @spice.key("updated_at") updatedAt: string,
}

@spice
type apiProduct = {
  @spice.key("product_id") productId: int,
  @spice.key("product_name") productName: string,
  @spice.key("unit_price") unitPrice: float,
  @spice.key("stock_quantity") stockQuantity: int,
  @spice.key("is_active") isActive: bool,
}

@spice
type apiOrder = {
  @spice.key("order_id") orderId: int,
  @spice.key("customer_id") customerId: int,
  @spice.key("order_date") orderDate: string,
  @spice.key("total_amount") totalAmount: float,
  @spice.key("shipping_address") shippingAddress: string,
}

// ============================================================================
// Records with @spice.default
// ============================================================================

@spice
type configWithDefaults = {
  host: string,
  @spice.default(3000) port: int,
  @spice.default(false) debug: bool,
  @spice.default(30) timeout: int,
  @spice.default(5) retries: int,
}

@spice
type userPrefsWithDefaults = {
  userId: int,
  @spice.default("en") language: string,
  @spice.default("light") theme: string,
  @spice.default(true) emailNotifications: bool,
  @spice.default(false) smsNotifications: bool,
}

// ============================================================================
// Deeply Nested Structures
// ============================================================================

@spice
type innerMost = {
  value: string,
  count: int,
}

@spice
type inner = {
  data: innerMost,
  label: string,
}

@spice
type middle = {
  inner: inner,
  priority: priority,
}

@spice
type outer = {
  middle: middle,
  status: status,
}

@spice
type deeplyNested = {
  outer: outer,
  metadata: metadata,
  coordinates: coordinates,
}

// ============================================================================
// Large Records (many fields)
// ============================================================================

@spice
type largeRecord = {
  field1: string,
  field2: string,
  field3: string,
  field4: string,
  field5: string,
  field6: int,
  field7: int,
  field8: int,
  field9: int,
  field10: int,
  field11: float,
  field12: float,
  field13: float,
  field14: float,
  field15: float,
  field16: bool,
  field17: bool,
  field18: bool,
  field19: bool,
  field20: bool,
  field21: option<string>,
  field22: option<string>,
  field23: option<int>,
  field24: option<int>,
  field25: option<bool>,
}

@spice
type extraLargeRecord = {
  a1: string, a2: string, a3: string, a4: string, a5: string,
  b1: int, b2: int, b3: int, b4: int, b5: int,
  c1: float, c2: float, c3: float, c4: float, c5: float,
  d1: bool, d2: bool, d3: bool, d4: bool, d5: bool,
  e1: option<string>, e2: option<string>, e3: option<string>, e4: option<string>, e5: option<string>,
  f1: option<int>, f2: option<int>, f3: option<int>, f4: option<int>, f5: option<int>,
  g1: array<string>, g2: array<string>, g3: array<int>, g4: array<int>, g5: array<bool>,
}

// ============================================================================
// Tuples
// ============================================================================

@spice
type point2D = (float, float)

@spice
type point3D = (float, float, float)

@spice
type range = (int, int)

@spice
type nameValue = (string, int)

@spice
type rgb = (int, int, int)

@spice
type rgba = (int, int, int, float)

// ============================================================================
// Type aliases
// ============================================================================

@spice
type userId = int

@spice
type email = string

@spice
type url = string

@spice
type jsonBlob = JSON.t

// ============================================================================
// More complex combinations
// ============================================================================

@spice
type searchResult = {
  query: string,
  results: array<product>,
  pagination: paginated<product>,
  facets: array<keyValue<string, int>>,
  metadata: metadata,
}

@spice
type dashboardData = {
  user: user,
  recentOrders: array<order>,
  savedProducts: array<product>,
  notifications: array<notification>,
  settings: settings,
  preferences: preferences,
}

@spice
type analyticsEvent = {
  eventType: event,
  userId: option<int>,
  sessionId: string,
  timestamp: timestamp,
  metadata: Dict.t<string>,
}

@spice
type auditLog = {
  id: int,
  action: string,
  actor: user,
  target: option<string>,
  changes: array<keyValue<string, string>>,
  timestamp: timestamp,
  metadata: metadata,
}
