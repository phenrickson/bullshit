import numpy as np
import matplotlib.pyplot as plt

# Generate synthetic data
np.random.seed(42)
x = np.linspace(-5, 5, num=50)
y_true = np.sin(x) + np.random.normal(0, 0.2, size=x.shape[0])

# Generate polynomial features
def generate_polynomial_features(x, degree):
    X_poly = np.zeros((len(x), degree+1))
    for d in range(degree+1):
        X_poly[:, d] = x**d
    return X_poly

# Fit polynomial regression models of varying degrees
degrees = [1, 4, 15]
colors = ['blue', 'green', 'red']
plt.figure(figsize=(12, 5))

for i, degree in enumerate(degrees):
    # Generate polynomial features
    X_poly = generate_polynomial_features(x, degree)
    
    # Fit the model
    coeffs = np.linalg.inv(X_poly.T.dot(X_poly)).dot(X_poly.T).dot(y_true)
    
    # Predict using the model
    y_pred = X_poly.dot(coeffs)
    
    # Plot the data points and the predicted curve
    plt.subplot(1, len(degrees), i+1)
    plt.scatter(x, y_true, color='black', label='Data')
    plt.plot(x, y_pred, color=colors[i], label='Degree {}'.format(degree))
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    
    # Calculate and display the mean squared error
    mse = np.mean((y_true - y_pred)**2)
    plt.title('Degree {}, MSE = {:.2f}'.format(degree, mse))

plt.tight_layout()
plt.show()

