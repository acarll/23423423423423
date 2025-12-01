import React from 'react';
import { HashRouter } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider } from './src/context/AuthProvider';
import { TenderProvider } from './src/context/TenderContext';
import { ToastProvider } from './src/context/ToastContext';
import AppRoutes from './src/routes/AppRoutes';
import ToastContainer from './components/ToastContainer';
import { ErrorBoundary } from './components/ErrorBoundary';
import { useTheme } from './src/hooks/useTheme';

// Initialize theme on app load
function ThemeInitializer() {
  useTheme();
  return null;
}

// Create a client
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

function App() {
  console.log('App component rendering...');

  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <ThemeInitializer />
        <ToastProvider>
          <AuthProvider>
            <TenderProvider>
              <HashRouter>
                <AppRoutes />
                <ToastContainer />
              </HashRouter>
            </TenderProvider>
          </AuthProvider>
        </ToastProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;