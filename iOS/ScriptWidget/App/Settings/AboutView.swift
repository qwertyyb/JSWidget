//
//  AboutView.swift
//  ScriptWidget
//

import SwiftUI
import UIKit

struct AboutView: View {
    private var copyrightYear: String {
        String(Calendar.current.component(.year, from: Date()))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                AboutAppIconView()
                
                Text(AppHelper.getAppDisplayName())
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Version \(AppHelper.getMarketingVersion())")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Build \(AppHelper.getBuildVersion())")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 24)
            
            Spacer(minLength: 24)
            
            VStack(spacing: 16) {
                AboutGitHubLink()
                AboutCopyrightFooter(year: copyrightYear)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 32)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarTitle(Text("About"), displayMode: .inline)
    }
}

private struct AboutAppIconView: View {
    var body: some View {
        Group {
            if let uiImage = AppHelper.appIconImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "app.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 88, height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct AboutCopyrightFooter: View {
    let year: String
    
    var body: some View {
        Button {
            if let url = URL(string: AppHelper.aboutAuthorURL) {
                UIApplication.shared.open(url)
            }
        } label: {
            (Text("Copyright © \(year) ")
                + Text(AppHelper.aboutAuthorName).underline())
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

private struct AboutGitHubLink: View {
    var body: some View {
        Button {
            if let url = URL(string: AppHelper.aboutRepositoryURL) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: 8) {
                AboutGitHubIconView()
                
                Text("View On GitHub")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .underline()
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

private struct AboutGitHubIconView: View {
    var body: some View {
        Group {
            if let uiImage = UIImage(named: "GitHubMark") {
                Image(uiImage: uiImage)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "link")
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .frame(width: 22, height: 22)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
