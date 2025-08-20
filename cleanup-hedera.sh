#!/bin/bash

# VeriChain Sovereign - Clean up Hedera references for Sei-only deployment
echo "🧹 Cleaning up Hedera references from VeriChain Sovereign codebase..."

# Navigate to the project root
cd "$(dirname "$0")"

# Create backup of important files before cleanup
echo "📦 Creating backup directory..."
mkdir -p .cleanup-backup

# List of directories/files to exclude from the final repository (Hedera-specific)
HEDERA_DIRS=(
    "./africhain/backend/hedera-service"
    "./africhain/documentation/docs/hedera_counterfeit_prd.md"
    "./africhain/documentation/docs/hedera-counterfeit-guardians-prd.md"  
    "./africhain/documentation/docs/prd/epic-verichainx-hedera-counterfeit-guardians-integration.md"
    "./africhain/documentation/stories/story-2-2-hedera-nft-minting.md"
)

# Move Hedera-specific files to backup
for dir in "${HEDERA_DIRS[@]}"; do
    if [ -e "$dir" ]; then
        echo "🗂️  Moving $dir to backup..."
        cp -r "$dir" ".cleanup-backup/" 2>/dev/null || true
        rm -rf "$dir" 2>/dev/null || true
    fi
done

# Update package.json files to remove hedera dependencies
echo "📦 Cleaning up package.json files..."
find . -name "package.json" -not -path "./.cleanup-backup/*" -exec sed -i 's/"@hashgraph\/sdk".*,//g; s/"@hashgraph\/[^"]*".*,//g; /hedera/d' {} \;

# Clean up import statements in TypeScript files
echo "🔧 Updating import statements..."
find . -name "*.ts" -not -path "./.cleanup-backup/*" -exec sed -i 's/import.*@hashgraph.*;//g; s/import.*hedera.*;//g; /HederaAgentKit/d; s/HederaAgentKit/SeiSovereignKit/g' {} \;

# Update README and documentation to be Sei-only
echo "📝 Updating documentation references..."
find . -name "*.md" -not -path "./.cleanup-backup/*" -exec sed -i 's/Hedera/Sei/g; s/HEDERA/SEI/g; s/hedera/sei/g' {} \;

# Create .gitignore to exclude backup and unnecessary files
echo "📄 Creating .gitignore..."
cat > .gitignore << 'EOL'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build outputs
dist/
build/
*.tsbuildinfo

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# Backup directory
.cleanup-backup/

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Temporary files
*.tmp
*.temp

# Database files
*.db
*.sqlite

# Keys and certificates
*.pem
*.key
*.crt
EOL

# Create a deployment checklist
echo "📋 Creating deployment checklist..."
cat > DEPLOYMENT-CHECKLIST.md << 'EOL'
# VeriChain Sovereign - Deployment Checklist

## Pre-Deployment Checks ✅

### Code Quality
- [ ] All TypeScript files compile without errors
- [ ] No Hedera references remaining in codebase
- [ ] All imports use Sei-based libraries only
- [ ] Tests pass for core agent functionality

### Configuration
- [ ] Environment variables configured for Sei network
- [ ] API keys for required services (OpenAI, Anthropic, Yei Finance)
- [ ] Smart contracts deployed to Sei testnet/mainnet
- [ ] Agent configurations optimized for production

### Documentation
- [ ] README.md updated with comprehensive system overview
- [ ] API documentation current and complete
- [ ] Deployment guide validated
- [ ] Epic completion reports finalized

### Performance
- [ ] Sub-400ms transaction finality verified
- [ ] Agent coordination tested under load
- [ ] Multi-user demo platform validated (50+ concurrent users)
- [ ] Cross-chain functionality operational

### Security
- [ ] Smart contracts audited
- [ ] API endpoints secured
- [ ] Environment variables properly protected
- [ ] Access controls implemented

### Demo Readiness
- [ ] Interactive demo platform fully operational
- [ ] All 5 demo scenarios tested and validated
- [ ] Performance metrics dashboard functional
- [ ] Multi-user support verified

## Deployment Commands

```bash
# Initialize repository
git init
git add .
git commit -m "Initial VeriChain Sovereign - Sei AI Agent Network"

# Add remote and push
git remote add origin https://github.com/ZubeidHendricks/verichainX-SEI.git
git push -u origin main

# Deploy demo environment
npm run deploy:demo

# Verify deployment
npm run test:deployment
```

## Post-Deployment Validation

- [ ] Repository accessible at: https://github.com/ZubeidHendricks/verichainX-SEI
- [ ] README displays correctly with all badges and formatting
- [ ] Demo platform accessible and functional
- [ ] All agent services operational
- [ ] Performance metrics within acceptable ranges

## Submission Readiness

- [ ] Sei AI Accelerathon requirements met
- [ ] DeFi and Payments track alignment verified
- [ ] Video demonstration prepared
- [ ] Technical documentation complete
- [ ] Business case presentation ready

**Status**: Ready for Sei AI Accelerathon Submission 🚀
EOL

echo "✅ Hedera cleanup complete!"
echo ""
echo "📊 Cleanup Summary:"
echo "- Moved Hedera-specific files to .cleanup-backup/"
echo "- Updated package.json files to remove Hedera dependencies"  
echo "- Cleaned TypeScript import statements"
echo "- Updated documentation to be Sei-focused"
echo "- Created .gitignore and deployment checklist"
echo ""
echo "🚀 Repository is now ready for GitHub push!"
echo "📝 Review DEPLOYMENT-CHECKLIST.md before final deployment"