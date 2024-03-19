# AR Music Visualizer

## Overview

This project, developed through processing composed of Java grammar, aimed to implement music visualization in AR. When a pre-trained marker is recognized by the camera, it has the function of expressing the visualized sound at the location in a bar shape. The user can adjust the visualization represented by moving or rotating the position of the marker.

## Features

- **Augmented Reality**: Utilizes AR to overlay music visualizations onto the real world, representing them as interactive dynamic graphics.
- **Sound Reactivity**: Sound visualization shows the frequency of the input sound in real-time response to the music.
- **Customizable Visuals**: Provides adjustable functionality for the number or color of the bars expressed.

## How It Works

- **AR**: It processes the overlay of sound visualization on the real world captured by the webcam. AR processing is performed using the `NyARToolkit` library. The coordinates are estimated on the AR through a pre-trained marker and processed by drawing a visual figure on those coordinates. 

- **Sound Processing**: Sound visualization processing is processed based on FFT. After dividing the spectrum at specific intervals, it is used by multiplying the weights.

## Getting Started

### Prerequisites

- Processing 3.x
- `NyARToolkit` AR library for Processing [https://nyatla.jp/nyartoolkit/wp/](https://nyatla.jp/nyartoolkit/wp/)
- Processing libraries (video, sound)

### Installation

1. Download and install Processing from [https://processing.org/](https://processing.org/).

2. Install the necessary libraries (`NyARToolkit`, `video`, `sound`) through the Processing IDE by navigating to `Sketch > Import Library... > Add Library...` and searching for these libraries except `NyARToolkit`. `NyARToolkit` library can be downloaded from [https://nyatla.jp/nyartoolkit/wp/](https://nyatla.jp/nyartoolkit/wp/).

3. Clone this repository or download my openprocessing sketch [https://openprocessing.org/sketch/1953178](https://openprocessing.org/sketch/1953178) (Does not work on the Web)

4. Open `AR.pde` and `MusicBar.pde` in Processing IDE.

5. Adjust the source code as needed to connect to path settings or audio file inputs.

### Running the Application

- Run `AR.pde` from the Processing IDE to start the AR music visualization. Ensure your webcam is enabled and functioning, as it's required for the AR functionality.

## Dependencies

- **Processing**: A flexible software sketchbook and a language for learning how to code within the context of the visual arts.
- **NyARToolkit**: An AR library for Processing, used for creating augmented reality applications.
