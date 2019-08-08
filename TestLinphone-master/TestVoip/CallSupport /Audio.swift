//
//  Audio.swift
//  TestVoip
//
//  Created by Edmund on 8/6/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import AVFoundation

func configureAudioSession() {
    print("Configuring audio session")
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory("playAndRecord", mode: "voiceChat", options: [])
    } catch (let error) {
        print("Error while configuring audio session: \(error)")
    }
}

func startAudio() {
    print("Starting audio")
}

func stopAudio() {
    print("Stopping audio")
}
