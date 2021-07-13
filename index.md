# Volume report generator

Use the this os x app to generate a report of project files and audio files that might be missing from the video servers.

![before](https://github.com/voxmedia/Volume_foder_report_generator/raw/master/img/start_screen.png)

![after](https://github.com/voxmedia/Volume_foder_report_generator/raw/master/img/report.png)

## Usage

Launch the app
Select Volume Folder to set the folder path of the folder that contains the video projects folders.
Save report to desktop generates a report on your desktop.
Video server folder structure

The app assumes there is the following folder structure on the video server.

```
└── Volume
       ├── SAMPLE_Project_1_folder
       │   └── ...
       └── SAMPLE_Project_1_folder
             └── ...
```

## Example of the .txt report being generated

```
Media Report_2016-Jun-07__11-07-29


Project Name: EXPORTS
Date: 2016-Apr-12__10-28-48
Project Path: /Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/EXPORTS
project files are missing from this project
audio files are missing from this project

 
Project Name: PROJECTS
Date: 2016-Apr-12__17-00-27
Project Path: /Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/PROJECTS
 
Project files: 
/Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/PROJECTS/dummy2.prproj
audio files are missing from this project

 
Project Name: ASSETS
Date: 2016-Apr-12__17-02-42
Project Path: /Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/ASSETS
project files are missing from this project
 
Audio files: 
/Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/ASSETS/dummy_audio5.mp3
/Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/ASSETS/dummy_audio6.wav

 
Project Name: MEDIA
Date: 2016-Apr-12__17-02-59
Project Path: /Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/MEDIA
project files are missing from this project
 
Audio files: 
/Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/MEDIA/dummy_audio7.wav
/Users/pietropassarelli/Dropbox/CODE/Vox/cue_sheet-scripts/Volume_report_generator/Volume_example/SAMPLE_Project_2_folder/MEDIA/dummy_audio8.mp3
```

## Issues

Get in touch at <pietro.passarelli@voxmedia.com>