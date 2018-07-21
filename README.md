# Hammerwatch Mouseaim
AutoHotkey script that enables playing Hammerwatch with mouse aim. Of course you can still only aim to one of the eight directions the game supports.

I have tested this by playing the full (standard) campaign with a Ranger. I played in window mode with the window maximized to screen size. I don't know if this also works in fullscreen mode. As the script runs in an endless loop, it might not run well on weak machines. I tested this on a Windows 7 64 Bit with a 3.4 GHz quad core (Intel Xeon E3-1231), 8 GB of RAM and a Gainward GTX 570 GLH. Also I used VSync to keep my GPU fan on a tolerable noise level (it limits the FPS to 60, otherwise I had over 100).

I have not tested multiplayer performance. I would expect no problems there, though.

## Setup

### Method 1: Using the Script with AutoHotkey (recommended)
1. [Download AutoHotkey](https://www.autohotkey.com/download/) (v1.1 or later).
2. Install AutoHotkey.
3. Download the `hammerwatch-mouseaim.ahk` and the `ch.gif` from this repository and put them in the same directory (you can choose freely).
4. You should be able to simply doubleclick the `ahk` file. If not, use *open with* and choose *AutoHotkey*.

### Method 2: Using the standalone Executable
1. Download one of the executables from the `bin` directory in this repository.
2. Download the `ch.gif` from this repository and put both files in the same directory (you can choose freely).
3. Run the executable.

## Usage

### Preparation of ingame Binds
In order to make the script work, you will have to rebind your ingame controls.

- **Up**: `I`
- **Down**: `K`
- **Left**: `J`
- **Right**: `L`
- **Strafe**: `M`
- **Hold**: `N`

These are **not** be the controls you will be using. You will control your character using `W`, `S`, `A` and `D`. You won't need to use *strafe* or *hold* manually at any point. The script does that for you.

I recommend to keep *attack* bound to `Up`. The following key links are set up in the script by default:

- `Up Arrow` <- `Left Mouse Button` (primary attack)
- `Left Arrow` <- `Right Mouse Button` (skill 1)
- `Right Arrow` <- `Left Shift` (skill 2)
- `Down Arrow` <- `Spacebar` (skill 3)

You can change ingame bindings for the skills, if you want. If you e.g. put *Skill 2* on `Down` and *Skill 3* on `Right`, `Left Shift` will trigger your third skill and `Spacebar` your second.

You can bind *Potion* and *Map* to your liking. I recommend keeping *Autofire hold* on `LCtrl`, otherwise you could need minor adjustments in the script, if you have set up special treatment for one of your attack keys. For more information, open the `ahk` in a code/text editor of your choice and search for *attackhotkeys*.

### Enabling and Disabling (IMPORTANT! READ!)
By default, the script is not enabled and will not work. Make sure your Hammerwatch window is active and all menus are closed. The script **will cause confusion** if used in any of the menus (including traders) and in any other application than Hammerwatch, because remember, **your left mouse button actually is your up arrow and moving your mouse will press and release some letters on your keyboard**.

To **enable or disable the script, press the asterisk `*` button on your numpad**. If you don't have a numpad, you'll have to rebind the toggle key. In order to do that open the script in a text or code editor of your choice, search for *enabledisablekey* and do your adjustments. In that case [this list](https://autohotkey.com/docs/KeyList.htm) might come in handy, too.

**Disable the script each time BEFORE you enter a trader and before you want to interact with any menu or want to switch to another application!** You can enable it after you closed all menus and trader windows and Hammerwatch is the active window again.

## Problems and Side Effects

### Weird Things are happening / My Mouse is not working anymore
Disable the script (default: `*` on your numpad).

### Each time I look into another direction, the Character stops for a few Milliseconds
This is normal. Internally, each time you change the direction with your mouse, the script has to stop your movement, press the *hold* button, adjust your direction with the respective movement key combination, then release the *hold* button and hold the *strafe* button. In order for the game to notice the button sequence, I had to apply a small delay. Feel free to commit any improvements, if you found some improvements.

### Sometimes my Character just doesn't look in the direction my Mouse is pointing to
I don't quite know what is causing that. Maybe the game sometimes doesn't notice all the key presses sent. To fix this, you will have to look in another direction, then back. Frantically circling the mouse pointer in the same directional segment won't help, even if this might be the intuitive reaction. 😉

### Sometimes my Character keeps moving, although I released the movement Buttons
Shortly press the same movement buttons again.

### Can I disable the Crosshair?
Yes. Open the script in a text or code editor of your choice and search for *disablecrosshair*. There are two lines with this tag. You have to prepend both with a semicolon in order to disable the crosshair.

### Can I change the Crosshair?
Yes. You can replace `ch.gif` with your own crosshair. The color white (#ffffff or (255, 255, 255)) will be replaced with transparency. If you decide to make your crosshair bigger or smaller, you will have to adjust the image size in the script. Therefore, open the script with your preferred text or code editor and search for *configuration*. I recommend using an image with odd width and height. Also, if there are non-transparent pixels near the center of the image, you will probably see your Windows cursor pop up while playing.

## My personal Experience
Although I had some of the problems explained above from time to time, I found it a very enjoyable experience. On my first playthrough years ago I used default controls and got cramps in my hands from time to time, because it was so exhausting to press all the key combinations for strafing and aiming and attacking.

Changing directions with the script causes the character to hang for a few milliseconds, but I really forgot about this after a few minutes of playing. It didn't prevent me from performing much better than on my first playthrough, even if I played solo (and on my first playthrough I played with three others). In my opinion, this control makes the game much much easier (and less crampy).

I recommend to try it out.
