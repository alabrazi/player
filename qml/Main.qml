import Felgo 3.0
import QtQuick 2.0
import QtMultimedia 5.9
import Qt.labs.folderlistmodel 2.2


App {
id:app
// property with json data
property var jsonData
property var difficultLyrics: []//this will contain lyrics marked as hard sorted by number of clicks plus the file name


//    function postJsonData() {
//        HttpRequest
//          .post(Qt.resolvedUrl("songs.json"))
//          .set('Content-Type', 'application/json')
//          .send({ title: "post title", body: "post body" })
//          .then(function(res) {
//            console.log(res.status);
//            console.log(JSON.stringify(res.header, null, 4));
//            console.log(JSON.stringify(res.body, null, 4));
//          })
//          .catch(function(err) {
//            console.log(err.message)
//            console.log(err.response)
//          });
//      }
    WebStorage {
      id: myWebStorage

      // this can be read in the Text element below
      property var lyricsData

      onInitiallyInServerSyncOrErrorChanged: {
        // also increase the app counter, if there is no internet connection
        if(initiallyInServerSyncOrError) {
          increaseAppStartedCounter()
        }
      }

//      function setLyricsData() {
//          myWebStorage.clearAll()
//        var weblyricsData = myWebStorage.getValue("lyricsData")
////         if the app was started for the first time, this will be undefined; in that case set it to 1

//        if(weblyricsData === undefined ) {
//          weblyricsData = page.jsonData
//           myWebStorage.setValue("lyricsData", weblyricsData)
//            console.log(myWebStorage,"x")
//        } else if (page.jsonData.length > weblyricsData.length) {
//            numNewItems = page.jsonData.length - weblyricsData.length
//            arrNewItems = b.splice(page.jsonData.length-newItems, weblyricsData.length)
//            arrFinalLyrics = weblyricsData.concat(arrNewItems)
//            console.log(arrFinalLyrics,"x")
//            myWebStorage.setValue("lyricsData", arrFinalLyrics)

//        }
//        lyricsData = myWebStorage.getValue("lyricsData")
//      }
    }

//    Navigation {
////       // enable both tabs and drawer for this demo
////       // by default, tabs are shown on iOS and a drawer on Android
////       navigationMode: navigationModeTabsAndDrawer
//       NavigationItem{
//           title: "Home"
//           icon: IconType.home
//              NavigationStack {}
//                  }
//    }


           NavigationStack {
               id:navStack
               Menu{
                   id:menuFileName
                   data:[1,2,3,4,5,6,7,8,9,10,11]
                   height: appbutton.height
           //        anchors.bottom: parent.top
                   anchors.right: parent.right
                   z:10000000


               }

               // list model for json data
               JsonListModel {
                   id: jsonModel
                   source: myWebStorage.lyricsData[menuFileName.currentIndex]
                   keyField: "id"
               }
               // list view

               Page {
                   id: page
                   title: "WeSWe"
                   property var dataModel: FolderListModel {
                       id: folderModel
                       nameFilters: ["*.mp3"]
                       folder: "../assets/"
                   }
                   Component {
                       id: subPage
                       Page {
                           title: "Sub Page"
                       }
                   }




                   Audio {
                       id: playMusic
                       //                                source: "../assets/"+ page.strCurrentlyPlaying
                       source: "../assets/"+ (menuFileName.currentIndex+1).toString() +".mp3"
                       autoPlay:false
                       autoLoad:false
                   }
                   AppListView {
                       id:myListView
                       //                anchors.fill: parent
                       model: jsonModel

                       y:3
                       delegate: SwipeOptionsContainer {
                           id: container
                           SimpleRow {
                               id:listItem
                               style.backgroundColor:!study?"white":["red","yellow","orange","pink","green","grey","blue","purple","cyan","magenta"][Math.floor(Math.random()*10)]
                               Column {
                                   //                                           width: myListView
                                   anchors.verticalCenter: parent.verticalCenter
                                   AppText {
                                       id:swedish
                                       text:position === 0? sw:"- "+ sw// round to 1 decimal
                                       fontSize: dp(6)
                                       anchors.horizontalCenter: parent.horizontalCenter
                                   }
                                   AppText {
                                       id: english
                                       //                                             anchors.top:swedish.bottom
       //                                padding: dp(10)
                                       text: position === 0? en:"- "+ en// round percent to 1 decimal
                                       fontSize: dp(5)
                                       anchors.horizontalCenter: parent.horizontalCenter
                                   }
                               }
                               //                                         text: model.title
                               // set an item that shows when swiping to the right
                               onSelected: {
       //                            page.navigationStack.push(subPage)

       //                            console.log(page.dataModel, index, fileName )
       //                            page.strCurrentlyPlaying = fileName
       //                            page.listData.push(modelData) // add copy of clicked element at end of model
                                   if(position === 0 ){
       //                            playMusic.seek(playMusic.position-5000)
                                   myWebStorage.lyricsData[menuFileName.currentIndex][index].clicks = clicks+1
                                   myWebStorage.lyricsData[menuFileName.currentIndex][index].position=playMusic.position - 1000
                                   }
                                   else{
                                   playMusic.seek(position)
                                       myWebStorage.lyricsData[menuFileName.currentIndex][index].clicks = clicks+1
       //                                postJsonData()
                                   }

       //                            var newItem = {
       //                                "id": jsonModel.count + 1,
       //                                "title": "Entry "+(jsonModel.count + 1)
       //                            }
       //                            page.jsonData[menuFileName.currentIndex].push(newItem)
       //                            // manually emit signal that jsonData property changed
                                   // JsonListModel thus synchronizes the list with the new jsonData
                                  myWebStorage.lyricsDataChanged()
       //                            page.dataModeChanged() // signal change of data to update the list
                               }
                           }
                           leftOption: SwipeButton {
                               icon: IconType.gear
                               height: parent.height
                               onClicked: {
       //                            english.opacity = !english.opacity
       //
       //                            page.jsonData[menuFileName.currentIndex][index].position = playMusic.position
                                    myWebStorage.lyricsData[menuFileName.currentIndex][index].study = !study
                                  myWebStorage.lyricsDataChanged()
                                   container.hideOptions() // hide button again after click

                               }
                           }
                           rightOption: SwipeButton {
                               icon: IconType.gear
                               height: parent.height
                               onClicked: {
       //                            listItem.enabled = false
                                  myWebStorage.lyricsData[menuFileName.currentIndex][index].study = 0
                                   myWebStorage.lyricsData[menuFileName.currentIndex][index].position = 0
                                  myWebStorage.lyricsDataChanged()
       //                             myWebStorage.setLyricsData()
                                   container.hideOptions() // hide button again after click
                               }
                           }

                       }
                       // transition animation for adding items
                       add: Transition {
                           NumberAnimation {
                               property: "opacity";
                               from: 0;
                               to: 1;
                               duration: 1000
                               easing.type: Easing.OutQuad;
                           }
                       }
                   }

                   Row{
                       anchors.bottom: parent.bottom
                       anchors.horizontalCenter: parent.horizontalCenter
                       AppButton {


                           id:appbutton
                           flat: true
                           //text: 'Reset'
                           borderWidth:0
                           icon: IconType.backward

                           onClicked: {
                               playMusic.seek(playMusic.position -5000)
                           }
                       }
                       // Button to add a new entry
                       AppButton {
                           borderWidth:0
                           id:pauseBtn
                           backgroundColor:"red"
                           backgroundColorPressed:"grey"
                           flat: true
                           rippleEffect : true
                           icon: {
                               if (playMusic.playbackState===1){
                               IconType.pause
                               }
                               else{
                                   IconType.play

                               }
                           }



                           //      text: "Add Entry"
                           onClicked: {
                               if (playMusic.playbackState===1){
                               playMusic.pause()
                               }
                               else{
                               playMusic.play()
                               }
                           }
                       }
                       // Button to add a new entry
                       AppButton {
                           borderWidth:0
                           id:addentry
                           backgroundColor:"red"
                           backgroundColorPressed:"grey"
                           flat: true
                           rippleEffect : true
                           icon: IconType.forward


                           //      text: "Add Entry"
                           onClicked: {
                               playMusic.seek(playMusic.position +5000)
                           }
                       }
                       // loadJsonData - uses XMLHttpRequest object to dynamically load data from a file or web service

                   }

                   //    AppButton {
                   //        flat: true
                   //anchors.left: addentry.right
                   //      anchors.bottom: parent.bottom
                   //borderWidth:0
                   //            onClicked: {
                   //                playMusic.seek(playMusic.position -5000)
                   //            }
                   //    }
               } // Pagex



    }


    function loadJsonData() {
      var xhr = new XMLHttpRequest
      xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
          var dataString = xhr.responseText


//            myWebStorage.clearAll()


          jsonData = JSON.parse(dataString)
            var lyricsData = myWebStorage.getValue("lyricsData")
            if(lyricsData === [undefined  ] || lyricsData ===undefined  ){
                 lyricsData = jsonData
                            myWebStorage.lyricsData = lyricsData
                            myWebStorage.setValue("lyricsData",lyricsData)

            }

            else if (jsonData.length > lyricsData.length) {
                        var numNewItems = jsonData.length - lyricsData.length
                        var arrNewItems = jsonData.splice(jsonData.length-numNewItems, jsonData.length)
                       var  arrFinalLyrics = lyricsData.concat(arrNewItems)
                 myWebStorage.lyricsData =arrFinalLyrics
                        myWebStorage.setValue("lyricsData", arrFinalLyrics)
//                         myWebStorage.lyricsData = myWebStorage.getValue("lyricsData")
                    }
            else{
                myWebStorage.lyricsData = lyricsData
            }

        }
      }
      xhr.open("GET", Qt.resolvedUrl("songs.json"))
      xhr.send()
    }
    // we load the data when the component was successfully created
    Component.onCompleted: {
      loadJsonData()
    }
    Component.onDestruction: {
      myWebStorage.setValue("lyricsData",myWebStorage.lyricsData)
    }
    }







//App {
//    id:app
//    width: 800
//    height: 600



//    // list model for json data

//    NavigationStack {
//        Component {
//            id: subPage
//            Page {
//                title: "Sub Page"
//            }
//        }

//        Page {
//            id:page
//            title: "WeSWeDish"
//            // property with json data
//            property var jsonData: [
//                {
//                    "id": 1,
//                    "title": "Entry 1"
//                },
//                {
//                    "id": 2,
//                    "title": "Entry 2"
//                },
//                {
//                    "id": 3,
//                    "title": "Entry 3"
//                }
//            ]
//            JsonListModel {
//                id: jsonModel
//                source: page.jsonData
//                keyField: "id"
//            }
//            navigationBarHidden: false
//            property var dataModel:                                   FolderListModel {
//                id: folderModel
//                nameFilters: ["*.mp3"]
//                folder: "../assets/"
//            }
//            property string strCurrentlyPlaying: ""



//            //            //            ScrollIndicator.vertical: ScrollIndicator { }
//            //            AppFlickable {
//            //                anchors.horizontalCenter: parent.horizontalCenter
//            //                anchors.fill: parent                // The AppFlickable fills the whole page
//            //                contentWidth: parent.width   // You need to define the size of your content item
//            //                contentHeight: contentColumn.height
//            //                //                            ScrollIndicator:true
//            //                Column {
//            //                    id: contentColumn
//            //                    anchors.horizontalCenter: parent.horizontalCenter

//Column{
//anchors.horizontalCenter: parent.horizontalCenter
//    Row{

//        spacing: dp(2)

//        Rectangle {
//            width: dp(30)
//            height: dp(30)
//            color: "black"
//            MouseArea{
//                anchors.fill: parent
//                onClicked: {
//                    playMusic.seek(playMusic.position -5000)
//                }
//            }

//        }
//        Text {
//            text: "Click Me!";
//            font.pointSize: 24;
//            height: 50;


//            Audio {
//                id: playMusic
//                //                                source: "../assets/"+ page.strCurrentlyPlaying
//                source: "../assets/"+ page.strCurrentlyPlaying

//            }
//            MouseArea {
//                id: playArea
//                anchors.fill: parent
//                onPressed:  {
//                    playMusic.play()
//                    //                      loader.sourceComponent=rect
//                    //                      var component = Qt.createComponent("Button.qml");
//                    //                      if (component.status == Component.Ready)
//                    rect.createObject(times); //, {"x": 100, "y": 100}
//                    times.forceLayout()
//                }
//            }
//        }
//        Rectangle {
//            width: dp(30)
//            height: dp(30)
//            color: "black"
//            MouseArea{
//                anchors.fill: parent
//                onClicked: {
//                    playMusic.seek(playMusic.position +5000)
//                }
//            }

//        }
//    }

//        ListView {


//            //                                  Component {
//            //                                      id: fileDelegate
//            //                                      Text { text: fileName }

//            //                                  }

//            model: page.dataModel
//            delegate:  SimpleRow {
//                text: fileName
//                onSelected: {
//                    page.navigationStack.push(subPage)

//                    page.strCurrentlyPlaying = fileName
//                    //                                        page.listData.push(modelData) // add copy of clicked element at end of model
//                    page.dataModelChanged() // signal change of data to update the list
//                }
//            }


//        }
//           AppListView {
//            //                anchors.fill: parent
//                            model: jsonModel
//                            delegate: SwipeOptionsContainer {
//                                id: container
//                                SimpleRow {
//                                    id:listItem
//                                    text: model.title
//                                    // set an item that shows when swiping to the right
//                                }
//                                leftOption: SwipeButton {
//                                    icon: IconType.gear
//                                    height: parent.height
//                                    onClicked: {
//                                        listItem.text = "Option clicked"
//                                        container.hideOptions() // hide button again after click
//                                    }
//                                }
//                            }
//                            // transition animation for adding items
//                            add: Transition {
//                                NumberAnimation {
//                                    property: "opacity";
//                                    from: 0;
//                                    to: 1;
//                                    duration: 1000
//                                    easing.type: Easing.OutQuad;
//                                }
//                            }
//                        }}



//            // Button to add a new entry
//            AppButton {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.bottom: parent.bottom

//                text: "Add Entry"
//                onClicked: {
//                    var newItem = {
//                        "id": jsonModel.count + 1,
//                        "title": "Entry "+(jsonModel.count + 1)
//                    }
//                    page.jsonData.push(newItem)

//                    // manually emit signal that jsonData property changed
//                    // JsonListModel thus synchronizes the list with the new jsonData
//                    page.jsonDataChanged()
//                }
//            }
//        }


//    }

//}
////}



////          AppButton {
////            text: "Play"
////            onClicked:{
//////                console.log(player.runJavaScript("player.getCurrentTime()"))
//////                runPlayerScript("getDuration", function(duration){
//////                  console.log("Video Duration: "+duration)
//////                })
//////            player. seekTo(5)
////                player.play()
////                playMusic.play()


////            }
////          }

////          AppButton {
////            text: "Pause"
////            onClicked: player.pause()
////          }

////          AppButton {
////            text: "Stop"
////            onClicked: player.stop()
////          }



////          Loader {
////              id:loader
////            // position the Loader in the center
////            // of the parent
//////            anchors.centerIn: parent// anchors.fill: parent
////  //          sourceComponent: rect
////                asynchronous: true
////            visible: status == Loader.Ready

////          }
////          Loader {
////            sourceComponent: rect
////          }

////      YouTubeWebPlayer {
////        id: player
////        videoId: "KQgqTYCfJjM"
////        playerVars: {
////          "controls": 0, // hide player controls
////          "showinfo": 0 // hide video title
////        }
////        enabled: true // no interaction with player possible
////      }
////      Video {
////          id: player
////          width : 800
////          height : 600
////          source: "2.mp3"
////          MouseArea {
////              anchors.fill: parent
////              onClicked: {
////                  MediaPlayer.MusicRole
////                  player.play()
////              }
////          }}

//// controls
////      Rectangle {
////        anchors.top: player.bottom
////        width: parent.width
////        height: controls.height
////        color: Theme.backgroundColor







////MouseArea {
////    id: playArea
////    anchors.fill: parent
////    onPressed:  {
////        playMusic.play()
////        console.log(playMusic.position)
////        //                      loader.sourceComponent=rect
////        //                      var component = Qt.createComponent("Button.qml");
////        //                      if (component.status == Component.Ready)
////        rect.createObject(times); //, {"x": 100, "y": 100}
////        times.forceLayout()
////    }
////}

////Component {

////    id: rect
////    Rectangle {
////        property int clicked: 0
////        id:retProp
////        width: 50
////        height: 50
////        color: ["red","yellow","orange","pink","green","black","grey","blue","purple","cyan","magenta"][Math.floor(Math.random()*10)]
////        enabled: retProp.opacity
////        MouseArea{
////            anchors.fill: parent
////            onClicked: {
////                retProp.clicked+=1
////                console.log("cli",retProp.clicked)
////                if (retProp.clicked=== 11){
////                    //                    retProp.opacity=0
////                    retProp.destroy()
////                }
////            }
////        }
////    }
////}
////Row{

////    anchors.horizontalCenter: parent.horizontalCenter

////    Grid{
////        //          anchors.horizontalCenter: parent.horizontalCenter
////        spacing: 20
////        id:times
////        add: Transition {
////            NumberAnimation { properties: "x,y"; from: 100; duration: 1000 }
////        }
////        move:Transition {
////            NumberAnimation { properties: "x,y"; from: 100; duration: 1000 }
////        }


////    }}

