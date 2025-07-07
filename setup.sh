#!/bin/bash

# Maestro Inventario Setup Script

echo "🚀 Setting up Maestro Inventario Development Environment"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL is not installed. Please install PostgreSQL or use Docker."
fi

echo "📦 Installing Backend Dependencies..."
cd backend
python3 -m venv venv

# Activate virtual environment (different for different systems)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

pip install --upgrade pip
pip install -r requirements.txt

echo "📱 Installing Frontend Dependencies..."
cd ../frontend
npm install

# Install Expo CLI globally if not present
if ! command -v expo &> /dev/null; then
    echo "📲 Installing Expo CLI..."
    npm install -g @expo/cli
fi

echo "🔧 Setting up environment files..."
cd ../backend
if [ ! -f .env ]; then
    cp .env.example .env
    echo "📝 Created .env file. Please update it with your database credentials."
fi

echo "✅ Setup complete!"
echo ""
echo "🔥 To start development:"
echo "1. Start PostgreSQL database"
echo "2. Update backend/.env with your database credentials"
echo "3. Run database migrations: cd backend && alembic upgrade head"
echo "4. Start backend: cd backend && python main.py"
echo "5. Start frontend: cd frontend && npm start"
echo ""
echo "Or use VS Code tasks: Ctrl+Shift+P -> Tasks: Run Task"
