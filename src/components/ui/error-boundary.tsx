"use client";

import React, { Component } from "react";
import { WarningCircle, ArrowClockwise } from "@phosphor-icons/react";

type Props = {
  children: React.ReactNode;
  fallbackMessage?: string;
};

type State = {
  hasError: boolean;
  error: Error | null;
};

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    console.error("ErrorBoundary caught:", error, info.componentStack);
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="flex flex-col items-center justify-center py-20 px-6">
          <WarningCircle
            weight="fill"
            className="h-12 w-12 text-red-400 mb-3"
          />
          <p className="text-lg font-medium text-gray-700 mb-1">
            Something went wrong
          </p>
          <p className="text-sm text-gray-500 mb-4 text-center max-w-md">
            {this.props.fallbackMessage ||
              "An unexpected error occurred. Try refreshing or click retry below."}
          </p>
          {this.state.error && (
            <pre className="mb-4 max-w-md overflow-auto rounded-lg bg-gray-50 p-3 text-xs text-gray-500">
              {this.state.error.message}
            </pre>
          )}
          <button
            onClick={this.handleRetry}
            className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-600 px-3.5 py-2 text-sm font-medium text-white hover:bg-indigo-700 transition-colors"
          >
            <ArrowClockwise weight="bold" className="h-4 w-4" />
            Retry
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
