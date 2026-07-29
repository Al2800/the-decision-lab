#!/bin/sh
# Export the current page of an open tldraw Desktop document to light + dark SVGs.
#
# Usage: scripts/export-diagram.sh <doc-name> <slug>
#   <doc-name>  case-insensitive substring of the open document's file name
#   <slug>      output basename; writes static/diagrams/<slug>-light.svg and
#               static/diagrams/<slug>-dark.svg
#
# Requires: tldraw Desktop running, with the document open on the page to export.
set -eu

DOC_NAME="${1:?usage: export-diagram.sh <doc-name> <slug>}"
SLUG="${2:?usage: export-diagram.sh <doc-name> <slug>}"

SERVER_JSON="$HOME/Library/Application Support/tldraw/server.json"
[ -f "$SERVER_JSON" ] || { echo "tldraw Desktop does not appear to be running." >&2; exit 1; }
PORT=$(jq -r .port "$SERVER_JSON")
TOKEN=$(jq -r .token "$SERVER_JSON")

SITE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$SITE_ROOT/static/diagrams"
mkdir -p "$OUT_DIR"

DOC_ID=$(curl -s -X POST "http://localhost:$PORT/api/search" \
  -H 'content-type: application/json' \
  -H "authorization: Bearer $TOKEN" \
  -d "{\"code\":\"const docs = await api.getDocs({ name: \\\"$DOC_NAME\\\" }); if (!docs.length) throw new Error('No open tldraw document matches $DOC_NAME'); return docs[0].id\"}" \
  | jq -r '.result // empty')

[ -n "$DOC_ID" ] || { echo "No open tldraw document matches '$DOC_NAME'." >&2; exit 1; }
DOC_ID_ENC=$(jq -rn --arg v "$DOC_ID" '$v | @uri')

RESP=$(curl -s -X POST "http://localhost:$PORT/api/doc/$DOC_ID_ENC/exec" \
  -H 'content-type: application/json' \
  -H "authorization: Bearer $TOKEN" \
  -d '{"code":"const ids = editor.getCurrentPageShapes().map(s => s.id); const light = await editor.getSvgString(ids, { background: false, darkMode: false }); const dark = await editor.getSvgString(ids, { background: false, darkMode: true }); const enc = (s) => btoa(unescape(encodeURIComponent(s))); return { lightB64: enc(light?.svg ?? \"\"), darkB64: enc(dark?.svg ?? \"\") }"}')

echo "$RESP" | jq -r '.result.lightB64' | base64 -D > "$OUT_DIR/$SLUG-light.svg"
echo "$RESP" | jq -r '.result.darkB64'  | base64 -D > "$OUT_DIR/$SLUG-dark.svg"

echo "Wrote $OUT_DIR/$SLUG-light.svg and $SLUG-dark.svg"
