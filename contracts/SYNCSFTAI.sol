// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SYNCSFTAI Token (BEP-20 on BNB Smart Chain)
 * @notice
 *  - Network: BNB Smart Chain (BSC)
 *  - Standard: BEP-20 (ERC-20 compatible)
 *  - Fixed supply: 10,000,000,000 SYNCSFTAI (18 decimals)
 *  - All tokens are minted once to the deployer address.
 *
 *  GÜVENLİK & ŞEFFAFLIK:
 *  - Owner / admin adresi YOK (contract üzerinde ayrıcalıklı yetki yoktur)
 *  - Mint fonksiyonu YOK (toplam arz arttırılamaz)
 *  - Burn fonksiyonu YOK (kontrat kendi başına arzı azaltmaz)
 *  - Tax / vergi YOK
 *  - Blacklist / dondurma YOK
 *  - Pause / trading durdurma YOK
 *
 *  Sadece standart ERC-20 fonksiyonları:
 *  - balanceOf, transfer, allowance, approve, transferFrom
 */

contract SYNCSFTAI {
    // === Temel ERC20 değişkenleri ===
    string private _name;
    string private _symbol;
    uint8  private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // === Event'ler ===
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // === Constructor ===
    constructor() {
        _name = "SYNCSFTAI";
        _symbol = "SYNCSFTAI";
        _decimals = 18;

        // 10,000,000,000 * 10^18
        uint256 initialSupply = 10_000_000_000 * (10 ** uint256(_decimals));

        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;

        emit Transfer(address(0), msg.sender, initialSupply);
    }

    // === ERC20 metadata ===

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // Toplam arz
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // === Temel ERC20 fonksiyonları ===

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "SYNCSFTAI: transfer amount exceeds allowance");

        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);

        return true;
    }

    // === Internal yardımcı fonksiyonlar ===

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "SYNCSFTAI: transfer from the zero address");
        require(to != address(0), "SYNCSFTAI: transfer to the zero address");
        require(_balances[from] >= amount, "SYNCSFTAI: transfer amount exceeds balance");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "SYNCSFTAI: approve from the zero address");
        require(spender != address(0), "SYNCSFTAI: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
