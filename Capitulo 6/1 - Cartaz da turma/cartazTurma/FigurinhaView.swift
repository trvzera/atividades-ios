//
//  FigurinhaView.swift
//  cartazTurma
//
//  Created by COTEMIG on 03/11/26.
//

import SwiftUI

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

struct FigurinhaView: View {
    @State private var posicao = CGSize.zero
    @State private var escala: CGFloat = 1
    @State private var angulo = Angle.zero

    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundStyle(Color.orange)
            .overlay{
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFill()
                    .padding(20)
                    .foregroundStyle(Color.white)
            }
            .scaleEffect(escala)
            .rotationEffect(angulo)
            .offset(posicao)
            .gesture(
                DragGesture()
                    .onChanged { valor in
                        posicao = valor.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            posicao = .zero
                        }
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { valor in
                        let novaEscala = valor
                        escala = min(max(novaEscala, 0.5), 2.5)
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { valor in
                        angulo = valor
                    }
            )
    }
}
