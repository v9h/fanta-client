# Fanta Client - Client sided audio visualizer

A **real-time audio visualizer** for Roblox that creates dynamic bars reacting to sound playback.

---

## Features
- **Sound Bars**   
  - Animated bars that react to the song's loudness.
  - **Transparent & rounded design** for seamless integration with the game.  
- **RGB Color Cycling**  
  - Bars cycle through **a smooth rainbow effect** over time.
  - Uses HSV conversion for a natural gradient.
- **Automatic Cleanup**   
  - Deletes the sound file after playback to save space.
  - Removes UI and cleans up objects.

---

## Setup & Customization

| Option           | Description |
|------------------|-------------|
| `link` | Set this to your audio file URL. |
| `numBars` | Adjust the number of visualizer bars. |
| `barWidth` | Controls how wide each bar is. |
| `spacing` | Sets the gap between bars. |

---

## How It Works
1. **Loads a sound file** from a given URL.  
2. **Creates animated bars** at the bottom of the screen.   
3. **Cleans up** all files and objects once the song ends.  

---

## Notes
- Ensure your executor has the **necessary functions** in order to get and play the files.
- The **RGB effect uses HSV color cycling**, making it smooth and natural.  
- **Higher `numBars` values may impact performance** on lower-end devices.  

---

## License
This project is open-source. Feel free to **modify and improve** it as needed!  
