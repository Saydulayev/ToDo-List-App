//
//  SearchBarView.swift
//  ToDo List App
//
//  Created by Saydulayev on 23.11.24.
//

import SwiftUI
import Speech

struct SearchBarView: View {
    @Binding var searchText: String
    @State private var isListening = false
    @State private var speechRecognizer = SFSpeechRecognizer()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private struct Constants {
        
        static let backgroundColor = Color(red: 0.153, green: 0.153, blue: 0.158)
        static let iconColor = Color.white.opacity(0.5)
        static let textColor = Color.white.opacity(0.5)
        static let listeningColor = Color.red
        
        
        static let cornerRadius: CGFloat = 10
        static let frameWidth: CGFloat = 370
        static let frameHeight: CGFloat = 36
        static let hStackSpacing: CGFloat = 3
        static let horizontalPadding: CGFloat = 26
        static let iconWidth: CGFloat = 17
        
        
        static let fontName = "SF Pro Text"
        static let fontSize: CGFloat = 17
        
        
        static let searchIconName = "magnifyingglass"
        static let microphoneIconName = "microphone.fill"
        static let microphoneActiveIconName = "microphone.badge.ellipsis.fill"
        
        
        static let searchPlaceholder = "Search"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Constants.backgroundColor)
                .frame(width: Constants.frameWidth, height: Constants.frameHeight)
            
            HStack(spacing: Constants.hStackSpacing) {
                Image(systemName: Constants.searchIconName)
                    .foregroundColor(Constants.iconColor)
                
                TextField(Constants.searchPlaceholder, text: $searchText)
                    .font(.custom(Constants.fontName, size: Constants.fontSize))
                    .foregroundColor(Constants.textColor)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: toggleListening) {
                    Image(systemName: isListening ? Constants.microphoneActiveIconName : Constants.microphoneIconName)
                        .foregroundColor(isListening ? Constants.listeningColor : Constants.iconColor)
                        .frame(width: Constants.iconWidth)
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .onAppear {
            requestSpeechAuthorization()
        }
    }
    
    private func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    private func startListening() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available")
            return
        }
        
        isListening = true
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                searchText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopListening()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
        }
    }
    
    private func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isListening = false
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition not available")
            }
        }
    }
}


