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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(#colorLiteral(red: 0.1531544924, green: 0.1531046033, blue: 0.1584302485, alpha: 1)))
                .frame(width: 370, height: 36)
            
            HStack(spacing: 3) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.white.opacity(0.5))
                    .frame(width: 20, height: 22)
                
                TextField("Search", text: $searchText)
                    .font(.custom("SF Pro Text", size: 17))
                    .foregroundStyle(Color.white.opacity(0.5))
                    .frame(height: 22)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: toggleListening) {
                    Image(systemName: isListening ? "microphone.badge.ellipsis.fill" : "microphone.fill")
                        .foregroundStyle(isListening ? .red : Color.white.opacity(0.5))
                        .frame(width: 17, height: 22)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                }
            }
            .padding(.horizontal, 26)
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
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not available")
            @unknown default:
                fatalError()
            }
        }
    }
}

