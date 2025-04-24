# Double Check 👀

**Double Check** is little game made for the **[Playdate](https://play.date)** during the **[PlayJam 5](https://itch.io/jam/playjam-5)** game jam. The game is simple, **Jerry** is about to leave the house for a special event. You have a **list of items** that Jerry needs to take with him. **Double check** to make sure he has everything he needs.

<p align="center">
  <img src="/publish/showcase.gif" />
</p>

## Description of the Game 🎮

The game loop is very simple. You see a **list of items** that **Jerry** needs to take with him for **five seconds**. Once that time is up, you'll see Jerry with some of the items. You then need to **figure out which items are missing** (sometimes nothing is missing) and **choose the correct one**. You only have **three lives**. The main objective is to **get a high score**. The game is a bit of a mix between a **memory game** and a **guessing game**. The game is designed to be played in **short bursts**, so you can pick it up and play for a few minutes at a time.

You can grab the **compiled app** from [itch.io](https://divingavran.itch.io/double-check). If you enjoy tinkering with code, feel free to **download the source code** from this repository and **compile it yourself using `pdc`** 🧑‍💻

## Information on Source Code 🧑‍💻

This project is just a simple **Playdate app** built using the **official Playdate SDK**. It's written in **Lua** and uses the **Playdate's built-in graphics and input libraries**. I've done my best to make the code readable, adding comments here and there to explain things. 📝 The code is separated into different files / folders to hopefully keep things organized. The main files / folders are:

- `main.lua`: The **main entry point** of the application. It **initializes the app** and **handles the main game loop**.
- `scenes`: This folder contains the **different scenes** of the app.
- `nodes`: This folder contains the **different reusable bits** used in the app.

## Support 💖

If you find this little app or its source code helpful, maybe consider **supporting my work**? 😊 You can find me on **[Ko-fi](https://ko-fi.com/divin)** or leave a **small donation via [itch.io](https://divingavran.itch.io/double-check)**. **Any support truly helps** me keep tinkering and hopefully improving things! Thank you! 🙏

## Credits 🙏

- **UI Sounds**: The lovely **UI sounds** are from [Pixabay](https://pixabay.com). I did some minor editing to make them fit just right. You can find the sounds in the `source/assets/sounds/fx` folder (except `loop.wav` which is some generic beat made by me). Apologies, but I downloaded several sounds before picking the final ones, so I don't have the specific links handy anymore.
