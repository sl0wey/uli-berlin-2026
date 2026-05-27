# ULI Berlin 2026 — Map & Timeline

Interactive one-page view of the **ULI Europe Conference 2026** and the **Urban Leader Summit (ULS)**, Berlin · 1–3 June 2026.

- Single self-contained `index.html` — no build step, no runtime dependencies beyond two CDNs (Leaflet + Google Fonts).
- Left pane: Leaflet map of all published venues. Right pane: three vertically-stacked day Gantts with sticky day headers.
- Sessions without a published venue are visibly flagged and excluded from the map.

Target deployment: `uli.bluecon-eng.com`.

---

## Quickest way to ship it

Three options, ordered by effort. Pick one — you don't need all three.

### Option A · GitHub Pages (~5 min, zero infra)

The simplest path. You push the repo, GitHub hosts it, you point the subdomain.

1. Create a public repo on GitHub: `sl0wey/uli-berlin-2026`
2. In this folder, run:
   ```bash
   cd /Users/maximilianschott/code/ULI
   git init
   git add .
   git commit -m "Initial commit: ULI Berlin 2026 map & timeline"
   git branch -M main
   git remote add origin https://github.com/sl0wey/uli-berlin-2026.git
   git push -u origin main
   ```
3. On GitHub → repo **Settings** → **Pages** → **Source: Deploy from branch** → `main` / `/ (root)` → Save.
4. Add a `CNAME` file to the repo containing `uli.bluecon-eng.com` (one line, no protocol):
   ```bash
   echo "uli.bluecon-eng.com" > CNAME
   git add CNAME && git commit -m "Custom domain" && git push
   ```
5. DNS (at whoever hosts `bluecon-eng.com` DNS — likely the same place WordPress is hosted):
   ```
   uli   CNAME   sl0wey.github.io.
   ```
6. Back in GitHub Pages settings, type `uli.bluecon-eng.com` into "Custom domain" and tick **Enforce HTTPS** once the cert provisions (5–15 min).

That's it. Free SSL, free hosting, auto-deploys on every push.

### Option B · Cloudflare Pages (~5 min, marginally nicer than A)

If `bluecon-eng.com` DNS is on Cloudflare, this becomes one-click. Same idea as GitHub Pages but Cloudflare's UI handles the certificate and CNAME for you.

1. Push the repo to GitHub (steps 1–2 above).
2. dash.cloudflare.com → **Workers & Pages** → **Create** → **Pages** → **Connect to Git** → pick `sl0wey/uli-berlin-2026`.
3. Build settings: **Framework: None**. **Build command:** *(empty)*. **Build output:** `/` (root).
4. Deploy. Cloudflare gives you `uli-berlin-2026.pages.dev`.
5. In the project → **Custom domains** → **Set up a custom domain** → `uli.bluecon-eng.com`. If Cloudflare manages the parent domain, the CNAME is added automatically.

### Option C · Coolify (you mentioned you already have it)

Use this if you want everything on your own server. The Dockerfile in this repo is Coolify-ready.

1. Push to GitHub as in Option A (steps 1–2).
2. In Coolify → **+ New Resource** → **Application** → **Public Repository** → paste the repo URL.
3. Build pack: **Dockerfile** (Coolify will auto-detect).
4. Port: **80** (already exposed by the Dockerfile).
5. Domain: `uli.bluecon-eng.com`. Coolify provisions Let's Encrypt SSL automatically.
6. DNS:
   ```
   uli   A   <your-coolify-server-IP>
   ```
   Or `CNAME` to whatever hostname your Coolify instance lives at.
7. Click **Deploy**. Future pushes to `main` redeploy automatically if you enable the webhook.

---

## My recommendation

**Use Option B (Cloudflare Pages)** if `bluecon-eng.com` is on Cloudflare DNS — it's the cleanest setup and gives you global CDN + DDoS protection for free.

**Use Option A (GitHub Pages)** if you don't want to involve Cloudflare. Same effort, slightly less polish on cache.

**Use Option C (Coolify)** only if you want this asset to live on the same server as your other Bluecon services. The Dockerfile is here in case you ever decide to consolidate.

For a single static HTML page, Coolify is overkill — but the setup is identical effort once the repo exists.

---

## Files in this repo

```
index.html          # the entire app — open in a browser
Dockerfile          # nginx:alpine, for Coolify / any Docker host
nginx.conf          # static-serve config with gzip + cache headers
.gitignore          # ignores the source PDFs and editor cruft
.dockerignore       # keeps the image small
README.md           # this file
```

## Source data

Built from the published programmes:
- `ULI-Europe-Conference-2026_Berlin_Full-Programme_EXTERNAL.pdf` (as at 20/05/2026)
- `ULS KONFERENZPROGRAMM A4_vol7.pdf`

Both PDFs are ignored from the repo (large, public elsewhere). Keep local copies if you want to regenerate or update sessions.

## Updating sessions

All session data lives inline in `index.html` — search for `const sessions = [` near the bottom of the `<script>` block. Each session is a plain object:

```js
{event:"europe"|"uls", day:"2026-06-0X", start:"HH:MM", end:"HH:MM",
 audience:"open"|"prereg"|"invite"|"yl"|"next"|"members",
 title:"...", venue:"<venue_id>" | null, note:"..."}
```

`venue` must reference a key in the `venues` object above it, **or `null`** if no location is published. Null-venue sessions show a 📍 marker and are excluded from the map.

## License / attribution

Map tiles © OpenStreetMap contributors via CARTO. Font: Jost (SIL Open Font License). Leaflet 1.9.4 (BSD-2).
