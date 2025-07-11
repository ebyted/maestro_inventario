"""fix_schema_mismatches_product_variant_unit

Revision ID: ec46e98132fb
Revises: a4fbc6569610
Create Date: 2025-07-06 03:19:39.178316

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'ec46e98132fb'
down_revision = 'a4fbc6569610'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    # op.drop_index('ix_user_roles_id', table_name='user_roles')  # Comentado: el índice no existe en una base limpia
    # op.drop_table('user_roles')
    # op.drop_index('ix_stock_alerts_id', table_name='stock_alerts')
    # op.drop_table('stock_alerts')
    # op.drop_index('ix_inventory_adjustments_id', table_name='inventory_adjustments')
    # op.drop_table('inventory_adjustments')
    # op.drop_index('ix_sales_id', table_name='sales')
    # op.drop_table('sales')
    # op.drop_index('ix_inventory_id', table_name='inventory')
    # op.drop_table('inventory')
    # op.drop_index('ix_sale_items_id', table_name='sale_items')
    # op.drop_table('sale_items')
    # op.drop_index('ix_inventory_adjustment_items_id', table_name='inventory_adjustment_items')
    # op.drop_table('inventory_adjustment_items')
    # ### end Alembic commands ###
    pass


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('inventory_adjustment_items',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('adjustment_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('product_variant_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('unit_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('expected_quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('actual_quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('difference', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('unit_cost', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('total_cost_impact', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['adjustment_id'], ['inventory_adjustments.id'], name='inventory_adjustment_items_adjustment_id_fkey'),
    sa.ForeignKeyConstraint(['product_variant_id'], ['product_variants.id'], name='inventory_adjustment_items_product_variant_id_fkey'),
    sa.ForeignKeyConstraint(['unit_id'], ['units.id'], name='inventory_adjustment_items_unit_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='inventory_adjustment_items_pkey')
    )
    op.create_index('ix_inventory_adjustment_items_id', 'inventory_adjustment_items', ['id'], unique=False)
    op.create_table('sale_items',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('sale_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('product_variant_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('unit_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('unit_price', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('total_price', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['product_variant_id'], ['product_variants.id'], name='sale_items_product_variant_id_fkey'),
    sa.ForeignKeyConstraint(['sale_id'], ['sales.id'], name='sale_items_sale_id_fkey'),
    sa.ForeignKeyConstraint(['unit_id'], ['units.id'], name='sale_items_unit_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='sale_items_pkey')
    )
    op.create_index('ix_sale_items_id', 'sale_items', ['id'], unique=False)
    op.create_table('inventory',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('warehouse_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('product_variant_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('unit_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('minimum_stock', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('maximum_stock', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('updated_at', postgresql.TIMESTAMP(timezone=True), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['product_variant_id'], ['product_variants.id'], name='inventory_product_variant_id_fkey'),
    sa.ForeignKeyConstraint(['unit_id'], ['units.id'], name='inventory_unit_id_fkey'),
    sa.ForeignKeyConstraint(['warehouse_id'], ['warehouses.id'], name='inventory_warehouse_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='inventory_pkey')
    )
    op.create_index('ix_inventory_id', 'inventory', ['id'], unique=False)
    op.create_table('sales',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('warehouse_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('user_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('sale_number', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('date', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
    sa.Column('payment_method', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('subtotal', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('tax', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('discount', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('total', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('customer_name', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('customer_email', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('notes', sa.TEXT(), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], name='sales_user_id_fkey'),
    sa.ForeignKeyConstraint(['warehouse_id'], ['warehouses.id'], name='sales_warehouse_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='sales_pkey'),
    sa.UniqueConstraint('sale_number', name='sales_sale_number_key', postgresql_include=[], postgresql_nulls_not_distinct=False)
    )
    op.create_index('ix_sales_id', 'sales', ['id'], unique=False)
    op.create_table('inventory_adjustments',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('warehouse_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('adjustment_number', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('adjustment_type', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('reason', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('notes', sa.TEXT(), autoincrement=False, nullable=True),
    sa.Column('user_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('status', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('approved_by', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('approved_at', postgresql.TIMESTAMP(timezone=True), autoincrement=False, nullable=True),
    sa.Column('applied_at', postgresql.TIMESTAMP(timezone=True), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['approved_by'], ['users.id'], name='inventory_adjustments_approved_by_fkey'),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], name='inventory_adjustments_user_id_fkey'),
    sa.ForeignKeyConstraint(['warehouse_id'], ['warehouses.id'], name='inventory_adjustments_warehouse_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='inventory_adjustments_pkey'),
    sa.UniqueConstraint('adjustment_number', name='inventory_adjustments_adjustment_number_key', postgresql_include=[], postgresql_nulls_not_distinct=False)
    )
    op.create_index('ix_inventory_adjustments_id', 'inventory_adjustments', ['id'], unique=False)
    op.create_table('stock_alerts',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('warehouse_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('product_variant_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('alert_type', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('current_quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=False),
    sa.Column('minimum_quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('maximum_quantity', sa.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('is_resolved', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.Column('resolved_at', postgresql.TIMESTAMP(timezone=True), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['product_variant_id'], ['product_variants.id'], name='stock_alerts_product_variant_id_fkey'),
    sa.ForeignKeyConstraint(['warehouse_id'], ['warehouses.id'], name='stock_alerts_warehouse_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='stock_alerts_pkey')
    )
    op.create_index('ix_stock_alerts_id', 'stock_alerts', ['id'], unique=False)
    op.create_table('user_roles',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('user_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('business_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('role', sa.VARCHAR(), autoincrement=False, nullable=False),
    sa.Column('permissions', postgresql.JSON(astext_type=sa.Text()), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['business_id'], ['businesses.id'], name='user_roles_business_id_fkey'),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], name='user_roles_user_id_fkey'),
    sa.PrimaryKeyConstraint('id', name='user_roles_pkey')
    )
    op.create_index('ix_user_roles_id', 'user_roles', ['id'], unique=False)
    # ### end Alembic commands ###
