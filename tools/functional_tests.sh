#!/bin/bash

# Configuration
BASE_URL="${1:-http://localhost:3000}"
echo "Running functional tests against: $BASE_URL"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    echo "  Response: $2"
    exit 1
}

# 1. Test: Create a Post (POST /posts)
echo "---------------------------------------------------"
echo "test 1: Create a new post"
PAYLOAD='{"title":"Test Title","text":"Test Content"}'
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$BASE_URL/posts")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [[ "$HTTP_CODE" == "200" || "$HTTP_CODE" == "201" ]]; then
    pass "Post created successfully (HTTP $HTTP_CODE)"
    # Extract ID (simple extraction for portability, assumes "id": <number>)
    POST_ID=$(echo "$BODY" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    echo "  Created Post ID: $POST_ID"
else
    fail "Failed to create post. Expected 200/201, got $HTTP_CODE" "$BODY"
fi

if [ -z "$POST_ID" ]; then
    fail "Could not extract ID from response" "$BODY"
fi


# 2. Test: Get All Posts (GET /posts)
echo "---------------------------------------------------"
echo "test 2: Get all posts"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/posts")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [[ "$HTTP_CODE" == "200" ]]; then
    pass "Retrieved content list successfully (HTTP 200)"
else
    fail "Failed to get posts. Expected 200, got $HTTP_CODE" "$BODY"
fi


# 3. Test: Get Post by ID (GET /posts/:id)
echo "---------------------------------------------------"
echo "test 3: Get post by ID ($POST_ID)"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/posts/$POST_ID")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [[ "$HTTP_CODE" == "200" ]]; then
    pass "Retrieved specific post successfully (HTTP 200)"
    # Check if body contains our title
    if echo "$BODY" | grep -q "Test Title"; then
        pass "Verified content matches data created"
    else
        fail "Content mismatch. Expected 'Test Title' in body" "$BODY"
    fi
else
    fail "Failed to get post $POST_ID. Expected 200, got $HTTP_CODE" "$BODY"
fi


# 4. Test: Non-existent Post (GET /posts/999999)
echo "---------------------------------------------------"
echo "test 4: Get non-existent post"
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/posts/999999")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

# Depending on implementation, might be 404 or just empty 200. usually 404 is best practice.
# adjusting expectation based on typical express/typeorm assumption, validating it's NOT a crash (500)
if [[ "$HTTP_CODE" == "404" ]]; then
    pass "Correctly handled non-existent post (HTTP 404)"
elif [[ "$HTTP_CODE" == "200" ]]; then
     pass "Handled non-existent post gracefully (HTTP 200)"
     echo "  Note: Consider returning 404 for missing resources."
else
    fail "Unexpected behavior for missing post. Got $HTTP_CODE" "$BODY"
fi

echo "---------------------------------------------------"
echo -e "${GREEN}All functional tests passed!${NC}"
