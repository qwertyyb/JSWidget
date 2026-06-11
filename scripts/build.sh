#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---------- 用法说明 ----------
usage() {
  cat <<'HELP'
Usage: build.sh [--export | --testflight | --appstore]

  --export      仅导出 IPA，不上传（默认）
  --testflight  导出并上传到 TestFlight 内测
  --appstore    导出并上传到 App Store Connect 提交审核

Environment variables:
  APP_VERSION          对外版本号（默认 1.2.3）
  CI_BUILD_NUMBER      构建号（默认用 git commit count）
  AUTH_KEY_ID          App Store Connect API Key ID
  AUTH_KEY_ISSUER_ID   App Store Connect API Issuer ID
HELP
  exit 0
}

# ---------- 参数解析 ----------
MODE="export"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --export)     MODE="export";     shift ;;
    --testflight) MODE="testflight"; shift ;;
    --appstore)   MODE="appstore";   shift ;;
    --help|-h)    usage ;;
    *) echo "❌ Unknown option: $1" >&2; usage ;;
  esac
done

# ---------- 版本配置 ----------
MARKETING_VERSION="${APP_VERSION:-1.2.3}"

if [ -n "${CI_BUILD_NUMBER:-}" ]; then
  CURRENT_PROJECT_VERSION="$CI_BUILD_NUMBER"
else
  CURRENT_PROJECT_VERSION="$(git rev-list --count HEAD)"
fi

# ---------- 认证环境变量检测 ----------
MISSING_VARS=()
[ -z "${AUTH_KEY_ID:-}" ]        && MISSING_VARS+=("AUTH_KEY_ID")
[ -z "${AUTH_KEY_ISSUER_ID:-}" ] && MISSING_VARS+=("AUTH_KEY_ISSUER_ID")

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
  echo "❌ Missing required environment variables: ${MISSING_VARS[*]}" >&2
  echo "   Please export them before running this script." >&2
  exit 1
fi

AUTH_KEY_P8_PATH="$PROJECT_ROOT/.private_keys/AuthKey_${AUTH_KEY_ID}.p8"
if [ ! -f "$AUTH_KEY_P8_PATH" ]; then
  echo "❌ Auth key not found: $AUTH_KEY_P8_PATH" >&2
  echo "   Place your App Store Connect API key (.p8) at the path above." >&2
  exit 1
fi

ARCHIVE_PATH="$PROJECT_ROOT/build/ScriptWidget.xcarchive"
EXPORT_PATH="$PROJECT_ROOT/build/output"

# 根据模式选择 ExportOptions
case "$MODE" in
  export)     EXPORT_OPTIONS="$SCRIPT_DIR/ExportOptions-export.plist" ;;
  testflight) EXPORT_OPTIONS="$SCRIPT_DIR/ExportOptions-testflight.plist" ;;
  appstore)   EXPORT_OPTIONS="$SCRIPT_DIR/ExportOptions-appstore.plist" ;;
esac

echo "📦 Building ($MODE):"
echo "   MARKETING_VERSION=$MARKETING_VERSION"
echo "   CURRENT_PROJECT_VERSION=$CURRENT_PROJECT_VERSION"

# ---------- 前置依赖 ----------
echo "📦 Installing dependencies and building tools..."
cd "$PROJECT_ROOT"
pnpm install
pnpm build:tools

cd "$PROJECT_ROOT/Editor/editorfe"
pnpm run build

# ---------- 构建输出目录 ----------
mkdir -p "$PROJECT_ROOT/build"

# ---------- Archive ----------
echo "📦 Archiving..."
xcodebuild \
  -project "$PROJECT_ROOT/iOS/ScriptWidget.xcodeproj" \
  -scheme "ScriptWidget" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  clean archive \
  -archivePath "$ARCHIVE_PATH" \
  MARKETING_VERSION="$MARKETING_VERSION" \
  CURRENT_PROJECT_VERSION="$CURRENT_PROJECT_VERSION" \
  CODE_SIGN_IDENTITY=- \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO

# ---------- 导出 IPA ----------
echo "📦 Exporting IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -exportPath "$EXPORT_PATH" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$AUTH_KEY_P8_PATH" \
  -authenticationKeyID "$AUTH_KEY_ID" \
  -authenticationKeyIssuerID "$AUTH_KEY_ISSUER_ID" \

echo "✅ Done ($MODE)! IPA exported to: $EXPORT_PATH"
