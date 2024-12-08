# **Ruby Wallet System**

## **Overview**

This project is an internal wallet transactional system built using Ruby on Rails. It enables entities like users, teams, and stocks to have their own wallets to manage money. The system supports transferring funds between wallets, depositing, and withdrawing money while adhering to database integrity and validation rules.

Check the [wiki page](https://gitlab.com/farizaw/ruby-wallet-system/-/wikis/API-usage).

---

## **Features**

- Each entity (e.g., `User`, `Team`, `Stock`) has a **wallet** to manage funds.
- Supports **credit** (deposit), **debit** (withdraw), and **transfer** transactions.
- Transactions are handled in compliance with **ACID standards** using database transactions.
- Dynamic or persistent calculation of wallet balances.
- Built-in validations to ensure data integrity.
- Scalable design using **polymorphic relationships** and **Single Table Inheritance (STI)**.

---

## **Models and Relationships**

- **User**, **Team**, and **Stock**: Entities that own wallets.
- **Wallet**: Polymorphic model that tracks the balance for each entity.
- **Transaction**: Tracks money movement between wallets with fields like `source_wallet`, `target_wallet`, and `amount`.

---

## **Installation**

1. Clone the repository:
   ```bash
   git clone https://github.com/farizaw/ruby-wallet-system.git
   cd ruby-wallet-system
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start the Rails server:
   ```bash
   rails server
   ```

5. Open the app in your browser at `http://localhost:3000`.

---

## **Usage**

### **Creating Entities and Wallets**
In the Rails console:
```ruby
user = User.create(name: "Alice", email: "alice@example.com")
team = Team.create(name: "Team Alpha", description: "A great team!")

# Create wallets for entities
user_wallet = user.create_wallet
team_wallet = team.create_wallet
```

### **Performing Transactions**
```ruby
# Deposit money into User's wallet
Transaction.create!(target_wallet: user_wallet, amount: 100.00)

# Transfer money from User to Team
Transaction.create!(source_wallet: user_wallet, target_wallet: team_wallet, amount: 50.00)
```

### **Checking Wallet Balance**
```ruby
user_wallet.balance # Returns the calculated or stored balance
team_wallet.balance
```

---

## **Database Schema**

### **Users**
| Field      | Type    |
|------------|---------|
| id         | integer |
| name       | string  |
| email      | string  |
| created_at | datetime |
| updated_at | datetime |

### **Wallets**
| Field          | Type       |
|----------------|------------|
| id             | integer    |
| walletable_id  | integer    |
| walletable_type| string     |
| balance        | decimal    |
| created_at     | datetime   |
| updated_at     | datetime   |

### **Transactions**
| Field            | Type       |
|------------------|------------|
| id               | integer    |
| source_wallet_id | integer    |
| target_wallet_id | integer    |
| amount           | decimal    |
| created_at       | datetime   |
| updated_at       | datetime   |

---

## **Testing**

Run the test suite:
```bash
rails test
```

---

## **Future Improvements**

- Implement APIs for external integrations (e.g., RESTful endpoints).
- Add support for currency conversion.
- Build a user-friendly front-end interface.
- Implement advanced reporting and analytics for transactions.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## **Contributors**

- [Fariz A.](https://gitlab.com/farizaw)
