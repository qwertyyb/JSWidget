import { render, screen } from '@testing-library/react';
import App from './App';

test('renders dev shell with editor', () => {
  render(<App />);
  expect(screen.getByText(/You clicked/i)).toBeInTheDocument();
});
