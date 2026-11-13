package com.finrakshak.model;

public class Budget {

    private int budgetId;
    private int userId;
    private String category;
    private double amount;
    private String month;

    public Budget() {
    }

    public Budget(int budgetId, int userId, String category,
                  double amount, String month) {

        this.budgetId = budgetId;
        this.userId = userId;
        this.category = category;
        this.amount = amount;
        this.month = month;
    }

    public int getBudgetId() {
        return budgetId;
    }

    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }
}
