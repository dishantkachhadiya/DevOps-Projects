# Pomodoro Timer

A Pomodoro-technique productivity timer built with plain HTML, CSS, and JavaScript, no framework, no build step, no dependencies besides Google Fonts.

Project URL: https://roadmap.sh/projects/pomodoro-timer

## Features

- Start, pause, resume, reset, and skip the current session
- Configurable durations: focus length, short break, long break, and how many focus sessions happen before a long break
- Current session type always visible (Focus session / Short break / Long break)
- A dot tracker and running count of completed focus sessions
- A short audio chime plays when a session ends (generated with the Web Audio API, no audio file needed)
- Fully keyboard operable: Space bar starts/pauses the timer, all controls are real, focusable buttons with visible focus states
- Screen-reader announcements on every phase change via an `aria-live` region
- Responsive from small mobile screens up
- Respects `prefers-reduced-motion`

## Design notes

- The radial ring is the centerpiece instead of a flat progress bar, a nod to the technique's literal kitchen-timer origin.
- Each phase (focus / short break / long break) has its own accent color, so the current state is readable at a glance without reading any text.
- Two typefaces: **Fraunces** (serif) for the title, and **Space Mono** for the countdown and UI labels. The countdown specifically uses a monospaced, tabular-number font so the digits don't shift width as they change.
- No persistence (localStorage, etc.) is used intentionally, keeping the file fully self-contained and portable to any static host with zero backend.

## Tech

- Vanilla HTML, CSS, and JavaScript, a single `index.html` file
- Google Fonts: Fraunces, Space Mono
- Web Audio API for the end-of-session chime

## Running it locally

Just open `index.html` in a browser, no build step or server required.

## Deploying

Since it's a single static file with no build process, it can be deployed as-is to:

- **GitHub Pages:** push this folder to a repo, enable Pages in repo settings, point it at the branch/folder containing `index.html`
- **Vercel / Cloudflare Pages:** import the repo and deploy with no framework preset / no build command

## Notes

- Settings (focus/break durations, sessions before long break) reset the timer back to a fresh focus session and reset the completed-session count when saved.
- The audio chime requires a user interaction to have occurred first (a browser autoplay restriction), which is already satisfied since starting the timer is itself a click.
